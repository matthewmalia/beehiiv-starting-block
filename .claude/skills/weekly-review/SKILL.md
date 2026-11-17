---
name: weekly-review
description: Run the analyst's weekly review - per-post results for recently sent posts, the weekly report, proposed lessons and calendar suggestions - and update the publishing streak. Use 2-4 days after a send, or when the writer asks how a post or the newsletter is doing.
---

# /weekly-review

This routine reads from beehiiv and writes reports. It never changes a draft, never schedules anything, and never updates a beehiiv skill without the writer's OK. It is safe to run unattended.

## 1. Check what was sent

- `list_posts` for sends in the last 10 days. Compare with `ops/content-calendar.md`.
- beehiiv is the system of record. If a post was sent that the files don't show (or the time differs), fix the files and note the correction in the report.
- For each slot that has passed, set the status to `sent` (or `missed`) and fill in the actual send time and on-time column.

## 2. Delegate to the analyst

Ask the `analyst` agent for:

1. `performance.md` in the folder of each post sent 2–4 days ago that doesn't have one yet. A post sent less than 2 days ago is too fresh: note it and leave it for next time.
2. This week's report at `ops/reports/<ISO year>-W<week>.md`.
3. Updates to `ops/learnings.md`.
4. **First review only**, if beehiiv has sends from before Starting Block: a baseline from the last 5 of them in this week's report, so later posts have averages to compare with. Those posts have no folders; match by title.

Pass along any reader replies the writer has pasted into the chat this session, after adding them to `ops/replies.md` with the date and the post they answer (no names or emails).

## 3. Update the streak

In `ops/content-calendar.md`, using the on-time rule written there:

- **Streak** = consecutive on-time sends, counting back from the most recent slot. A short post sent on time keeps the streak.
- Update the summary line at the top.

## 4. Bring it to the writer

Show the report's one-line summary, the table row for each post, and the 1–2 things to try. Give the path to the full report. Keep it to what fits on one screen.

Then ask, one at a time and only if there is something to ask:

- **Proposed lessons:** "Two posts now support this: '…'. Add it to your voice skill?" On a yes, `get_skill` the current `voice-and-format`, add the lesson under *Lessons learned*, show the writer the changed section, then `save_skill` with the complete text. In paste-in mode (no skill id), make the same change in `beehiiv-skills/voice-and-format.md` instead. Record the approval date in `ops/learnings.md`.
- **Calendar or idea suggestions:** add them to `ops/ideas.md` marked *suggested*. Change the calendar only if the writer says so.

## 5. Check the runway

Finish with the status line, and flag anything that needs action:

- Next draft due date, and whether it has arrived.
- Posts waiting in `inbox/`: say how many.
- Planned slots left: if fewer than 2, offer `/plan-content`.
- The later skills, once each, as described under "Suggesting the later skills" in `CLAUDE.md`.
- On the Pro trial (`access.trial` is `likely` or `yes`): days left until `access.trial_ends_estimate` (say "about" when it's an estimate), and the plan decision if it is within 4 days.

## When running unattended (`claude -p "/weekly-review"`)

There is no one to answer questions. Do steps 1–3, write the report, and stop. Don't ask about lessons and don't call `save_skill`: leave proposed lessons in the report for the writer's next session. Print the report's one-line summary and its path as the final output.
