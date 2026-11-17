---
name: capture-voice
description: Build the writer's voice profile and save it as the voice-and-format beehiiv skill, so the editor knows which habits to protect and which house-style fixes to make. Learns from posts the writer has already submitted or sent, then asks a few short questions. Run after two or three posts, or when the editor's suggestions don't sound like the writer.
---

# /capture-voice

Until this runs, the editor works from a neutral starter: it fixes plain errors, keeps the draft consistent with itself, and protects the writer's wording. This routine replaces the starter with a description of how **this writer** actually writes.

A writer who brought 3 or more posts to `/start` already has a profile from them (`voice.captured: true`); for them this routine is a refresh, run when the editor's suggestions stop sounding like them. For a first-time writer it isn't part of getting started on purpose. It works better with real posts to learn from, and it shouldn't stand between a new writer and their first send.

## 1. Gather samples (no questions if you can avoid them)

Use, in this order, until you have at least three pieces:

1. `posts/_samples/` (posts the writer brought to `/start`) and `posts/*/draft.md` in this repo: the writer's own words before editing. Never use `final.md` as evidence of voice where it differs from the draft.
2. The decisions in `posts/*/edit-notes.md`: what they rejected is the strongest signal of what an editor must not change.
3. Recent sent posts in beehiiv (`list_posts`, `get_post_content` with `format: "text"`).
4. Only if there are fewer than three pieces: ask for two or three samples, pasted or saved in `inbox/`.

## 2. Draft the profile from the evidence

Fill in `templates/voice-and-format-full.md`. For every claim, have a short phrase from the samples that shows it. Describe what is there, not an improved version of it.

Work out from the samples, without asking:

- typical length, heading style, how they open and close, recurring section labels,
- spelling variety, how they write numbers and dates, dash and comma habits, emoji use,
- quirks an editor would be tempted to "fix" (fragments, lowercase headings, a recurring phrase),
- how their best-performing subject lines are built, if `ops/reports/` has results.

## 3. Ask only what the samples can't show

One at a time, and skip any the samples answered clearly:

1. Three words for how you want to sound, and what each one must not turn into (e.g. *conversational, not chatty*).
2. Is there anything you do on purpose that an editor should leave alone?
3. Any words or phrases you never want to see in your newsletter?
4. Do you want the same opening line and sign-off on every post? If so, what are they?
5. For a week when you're short on time: what does your short format look like? (About 200 words, one idea, unless you say otherwise.)
6. Are AI-generated thumbnails all right, or your own images only?

Copy over the reader and promise from `config/publication.yaml`. Ask about them only if they're empty.

## 4. Show it, then save it

1. Show the writer the **complete** profile. Ask what's wrong or missing. Revise until they approve.
2. Check it is under 10,000 characters (comments removed).
3. `get_skill` the current `voice-and-format` (id in the config) and carry over any approved *Lessons learned* into the new text. `save_skill` with that id and the complete new instructions. It replaces the whole document. In paste-in mode (no id), carry the lessons over from `beehiiv-skills/voice-and-format.md` and skip the upload: the repo file in step 4 is the only copy.
4. Save the approved text to `beehiiv-skills/voice-and-format.md` in the repo so the two stay the same, and set `voice.captured: true` and today's date in the config.

## 5. Apply what changed

- If they chose a fixed opening or sign-off, delegate to the `editor` to add those blocks to the post template around the body placeholder (`edit_post_template_content`). Show the writer before saving.
- If the default edit level should change (a writer who rejected most line edits probably wants `light`), suggest it and update the config on a yes.

End with one line on what the editor will now do differently, using two examples from their own profile.
