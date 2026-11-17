#!/usr/bin/env bash
#
# weekly-run.sh — run the unattended parts of the playbook from cron or any scheduler.
#
#   scripts/weekly-run.sh reminder   Print a draft-due reminder if one is due (2 days before
#                                    the due date, and on the due date). Prints nothing otherwise.
#   scripts/weekly-run.sh review     Run /weekly-review: per-post results and the weekly report.
#   scripts/weekly-run.sh all        Both (reminder first).
#
# What this never does: write a post, change a draft, schedule or send anything, or change a
# beehiiv skill. The tool lists below are read-only on beehiiv and schedule_post is denied outright.
#
# Before the first unattended run:
#   1. Sign in to the beehiiv MCP once on this machine. It uses OAuth in your browser: open
#      Claude Code in this repo, run /mcp and authenticate "beehiiv" (GUIDE.md §4).
#   2. Run this script by hand and confirm the sign-in still works the next day.
#
# Example crontab (machine's local time; send day Tuesday, draft due Sunday):
#   0 9 * * *   cd /path/to/repo && scripts/weekly-run.sh reminder >> ops/cron.log 2>&1
#   0 10 * * 5  cd /path/to/repo && scripts/weekly-run.sh review   >> ops/cron.log 2>&1
#
# Optional environment:
#   CLAUDE_BIN   path to the claude CLI (default: claude)
#   NOTIFY_CMD   a command that receives the reminder or summary text on stdin,
#                e.g. NOTIFY_CMD='mail -s "Newsletter" you@example.com'

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

CLAUDE_BIN="${CLAUDE_BIN:-claude}"
MODE="${1:-}"

if ! command -v "$CLAUDE_BIN" >/dev/null 2>&1; then
  echo "weekly-run: '$CLAUDE_BIN' not found. Install Claude Code or set CLAUDE_BIN." >&2
  exit 127
fi

# Local file tools. "Task" lets the main session hand work to the analyst agent.
FILE_TOOLS="Read,Write,Edit,Glob,Task"

# Read-only beehiiv tools: everything the weekly review needs and nothing that writes.
BEEHIIV_READ_TOOLS="mcp__beehiiv__get_workspace,mcp__beehiiv__list_publications,mcp__beehiiv__get_publication,mcp__beehiiv__get_skill,mcp__beehiiv__list_skills,mcp__beehiiv__list_posts,mcp__beehiiv__get_post,mcp__beehiiv__get_post_stats,mcp__beehiiv__get_post_stats_batch,mcp__beehiiv__get_publication_stats,mcp__beehiiv__list_post_clicks,mcp__beehiiv__get_post_isp_breakdown,mcp__beehiiv__get_subscriber_growth,mcp__beehiiv__get_subscriber_history,mcp__beehiiv__list_poll_responses,mcp__beehiiv__list_survey_responses,mcp__beehiiv__list_automations,mcp__beehiiv__get_automation_stats,mcp__beehiiv__get_website_analytics,mcp__beehiiv__get_website_analytics_breakdown"

# Denied even if a settings file would allow them.
DENIED_TOOLS="mcp__beehiiv__schedule_post,mcp__beehiiv__save_post,mcp__beehiiv__edit_post,mcp__beehiiv__edit_post_content,mcp__beehiiv__save_skill,mcp__beehiiv__save_automation,Bash"

notify() {
  # Print the text, and pass it to NOTIFY_CMD if one is set.
  local text="$1"
  [ -z "$text" ] && return 0
  printf '%s\n' "$text"
  if [ -n "${NOTIFY_CMD:-}" ]; then
    printf '%s\n' "$text" | bash -c "$NOTIFY_CMD" || echo "weekly-run: NOTIFY_CMD failed" >&2
  fi
}

run_reminder() {
  local today prompt out
  today="$(date +%Y-%m-%d)"
  prompt="Today is ${today}. Read config/publication.yaml (if present) and ops/content-calendar.md. \
Find the next slot whose status is planned. If its draft due date is today, or exactly \
the number of days from today listed in schedule.reminder_days_before_due (default 2), output one \
line and nothing else, in this form: Your draft for <send day> is due <due day> at <due time>: \
<working title>. Paste it into Claude or save it to inbox/. \
If no reminder is due, or the calendar has no slots, output exactly: NONE. \
Do not write or change any file. Do not write any part of a post."

  out="$("$CLAUDE_BIN" -p "$prompt" --allowedTools "Read,Glob" --disallowedTools "$DENIED_TOOLS")"
  if [ "$(printf '%s' "$out" | tr -d '[:space:]')" != "NONE" ]; then
    notify "$out"
  fi
}

run_review() {
  local out
  out="$("$CLAUDE_BIN" -p "/weekly-review" \
    --allowedTools "${FILE_TOOLS},${BEEHIIV_READ_TOOLS}" \
    --disallowedTools "$DENIED_TOOLS")"
  notify "$out"
}

case "$MODE" in
  reminder) run_reminder ;;
  review)   run_review ;;
  all)      run_reminder; run_review ;;
  *)
    echo "Usage: $0 {reminder|review|all}" >&2
    exit 64
    ;;
esac
