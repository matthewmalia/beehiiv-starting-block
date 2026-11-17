---
name: submit-draft
description: Take the writer's newsletter draft, pasted in the message or saved in inbox/, through editing, packaging, beehiiv build, and pre-send checks, then stop for the writer's approval. Use when the writer says their draft is ready, pastes a post, or asks to publish.
argument-hint: [light|standard|deep]
disable-model-invocation: true
---

# /submit-draft

Edit level: `$ARGUMENTS` (if empty, use `default_edit_level` from `config/publication.yaml`, else `standard`).

Follow these steps in order. The writer's time budget for everything here is about 30 minutes a week, so keep your messages short and ask for decisions in one batch.

## 1. Find the draft

- If the message contains a draft, use it.
- Otherwise look in `inbox/` (ignore `README.md`). If there is more than one file, take the one the calendar has in the next open slot and confirm it; ask only if the calendar doesn't say.
- If neither has one, say: *"Paste your draft here, or save it to `inbox/` (Markdown or plain text, images alongside) and tell me when it's there."* Then stop.

**Do not continue without the writer's own draft.** Never draft, extend or complete a post yourself. An outline or a list of bullet points is not a draft: say so, and offer a `deep` edit once it's written.

A post the writer is moving over from another newsletter or blog is a real draft: it is theirs and it is complete. Tell the editor it is `source: migrated` and use a `light` edit unless the writer asks for more.

If the message is a revision of a post that already has a folder ("here's v2"), treat it as a revision: same folder, same slot.

## 2. Match it to a slot

Read `ops/content-calendar.md`. Match the draft to the next open slot and confirm in one line: *"This is 'Why small lists win' for Tue Dec 1, 9:00. Right?"*
If there is no calendar yet, don't send the writer away to plan first: confirm the next occurrence of their send day as the slot, add it to the calendar, and carry on. Suggest `/plan-content` at the end.

Take the mode (`full` or `paste-in`) from `access.mode` in the config, as in "Modes" in `CLAUDE.md`. Don't decide it from `plan: "Free"` alone: the Pro trial reports Free too. If `access` is missing, run the write check first.

## 3. Intake and edit

Delegate **Stage 1** to the `editor` agent with: the draft (or its path), the send date, the edit level, and the mode. Set the calendar status to `editing`.

## 4. The writer's decisions

Show the writer:

- one line of summary (word count, how many mechanical fixes),
- the numbered suggestions and queries, in full,
- how to answer: *"accept all"*, or *"accept 1, 3; reject 2; for 4 use: …"*.

Collect a decision on every item. Queries need an answer in the writer's words. Don't nudge them to accept.

After a `deep` edit, stop here: the writer revises and resubmits.

## 5. Package, build, check, test

Delegate **Stage 2** to the `editor` with the decisions quoted exactly. When it returns three headlines and three subject lines, show them and let the writer pick or write their own, then pass the choice back so it can finish: `final.md`, `package.yaml`, the beehiiv build (or paste-in output), `qa.md`, and the test email.

## 6. Report

Tell the writer, briefly:

- the folder path and the `editor_url`,
- the subject line and its two alternatives,
- the checklist result, with any fail or open item first,
- that a test email is in their inbox (full mode), or the paste-in steps (paste-in mode).

Set the calendar status to `approved` only when the writer says the test looks right.

## 7. Stop

Schedule only if the writer says "schedule" (or an equally clear yes) **in this session, after seeing the report**:

- **Full, `access.can_schedule` is `yes` or `unknown`:** `schedule_post` at the calendar's send time, at least 10 minutes out. Relay the `editor_url`, the send time and the recipients. If it's rejected for plan reasons, set `can_schedule: no` and use the next line.
- **Full, `can_schedule: no`:** remind the writer to schedule in the beehiiv app, and give the `editor_url`.
- **Paste-in:** remind the writer to paste `final.md` and the package fields into the beehiiv editor and schedule there.

## 8. Update the records

- `ops/content-calendar.md`: status (`approved` → `scheduled` once it is), working title → final title, link to the folder.
- `package.yaml`: `beehiiv.scheduled_at` when known.
- Remove the processed file from `inbox/` if the editor hasn't already moved it.

Finish with the status line and **one** next action: what the writer should write next and when it is due, or, if more posts are waiting in `inbox/`, which one is up next.
