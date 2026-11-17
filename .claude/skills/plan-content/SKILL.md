---
name: plan-content
description: Plan the next four weeks of articles with the writer - one dated slot per week with a draft due date and a working title in the writer's words. Posts waiting in inbox/ get the first slots. Use right after getting started, monthly after that, or when the writer asks what to write next or wants to replan.
argument-hint: [weeks]
---

# /plan-content

Plan the next `$ARGUMENTS` weeks (default 4). The job is one thing: **set the writer up to write one article every week.** Each week gets a send date, a draft due date and a working title. Nothing else.

The ideas and working titles are the writer's. You may suggest one, marked *suggested*, but never outlines, openings or any text for a post. Every slot is an article: never plan curated links, link roundups or other formats.

## Before you ask anything

Read, quietly: `config/publication.yaml` (send day and time, time zone, `due_offset_days`, due time), `ops/content-calendar.md`, `ops/ideas.md`, every file in `inbox/` (ignore `README.md`), and `list_posts` (scheduled and sent), so nothing is planned twice and anything already scheduled in beehiiv is on the calendar.

## Ask

One question, in plain text:

> **What do you want to write about over the next four weeks?**

Take their answer as it comes: one theme, several topics, or specific titles.

If it gives fewer ideas than there are weeks (usually one theme), ask one follow-up in plain text:

> **Any particular angles on that for the other weeks?** Skip this and I'll put the theme on every week; you can sharpen each title when you write it.

## Propose the calendar

Build the slots:

- One slot per week, on the send day and time in the config.
- **Draft due** = send date minus `due_offset_days`, at the due time.
- **Posts in `inbox/` go first**, one per slot, in the order the writer gave (or filename order). Mark them *(in inbox)*.
- The **first new post** needs at least 4 days before its due date. Otherwise start at the earliest send that allows it.
- **What you'll write:** a working title for every week, in the writer's words, from their answers. Where those run out, use an idea from `ops/ideas.md` marked *suggested*, and after that the theme itself. Never leave a week blank or "TBD".

Show only this table:

| Send | Draft due | What you'll write |
|---|---|---|
| Tue Nov 24, 9:00 | Sun Nov 22, 6pm | Why small lists win |
| Tue Dec 1, 9:00 | Sun Nov 29, 6pm | What my first 100 replies taught me |

Then ask with `AskUserQuestion`: header "Calendar", question "Does this four-week plan work?", options **Looks good** / **Change something**. On "Change something", ask in plain text what to change, revise, and ask again.

## Save

1. Add the approved slots to `ops/content-calendar.md` with status `planned`. Keep past rows: they are the publishing history.
2. Add any ideas the writer mentioned that didn't get a slot to `ops/ideas.md`. Move an idea that did get a slot to *In the calendar*.
3. Ask with `AskUserQuestion`: header "Reminders", question "Want a reminder two days before each draft is due, and on the due date?", options **Yes, remind me** / **No thanks**. On a yes, set them up (see `scripts/weekly-run.sh` or a scheduled task).

End with the status line (next send, next draft due, inbox count) and one next action.
