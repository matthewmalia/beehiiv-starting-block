---
# Upload with save_skill. These four keys map to save_skill's fields; everything
# below the second --- line is the `instructions` text (keep it under 10,000 characters).
name: publishing-standards
description: Load before checking any post or automation email. Covers sourcing, disclosure, the pre-send checklist, privacy and corrections.
visibility: workspace      # needs a workspace admin; use private if you work alone
invocation_mode: both
---

# Publishing standards

These are the checks every post passes before the writer is asked to approve it. The writer wrote the post; these standards protect their words and their readers. If a check fails, report it. Don't fix a failure by rewriting the writer's text.

These are working defaults, uploaded by `/start` so a new writer can publish straight away. The writer can change any of them: "update my publishing standards: …".

## The writer's words

- The writer writes every post and the welcome email. Never add claims, examples, quotes, statistics or paragraphs.
- Mechanical fixes (spelling, grammar, punctuation, house style, broken or untidy links) may be applied without asking, and every one is listed.
- Anything that changes meaning, structure or tone is a numbered suggestion the writer accepts or rejects.
- An unclear fact becomes a question in the text: `[QUERY: is this 2025 or 2026?]`. Never resolve a query by guessing.

## Sourcing

- Link to the original source, not to coverage of it.
- Every statistic has a link, or the writer has said it is their own data and the text says so. Otherwise flag it as a `[QUERY]`.
- Quotes are exact and attributed. Don't tidy a quote.
- Check that every link resolves and goes where the text says it goes.

## Posts moved from another newsletter or blog

- Flag anything that has gone stale since it was first published: dates and "last week", prices, old product names, references to the previous platform ("subscribe on …", "like this post"), and links to the old site. Each is a `[QUERY]`, not a fix.
- If the writer asked for a "first published" line, check it's there. Never add one unasked.

## Disclosure

- **AI assistance line:** none by default. If the writer sets one (for example "Written by me. Edited and published with AI help."), check it appears in the footer.
- **Own products (brands):** call the product by its name and make clear when a mention is promotional.
- **Affiliate links:** a disclosure before the first affiliate link.
- **Sponsored content:** labelled "Sponsored" at the top of the section.

## Pre-send checklist

Run every item and record the result in `qa.md` as pass, fail or not applicable, with a note for anything that isn't a pass. Any fail blocks the request for approval.

1. **No open queries.** No `[QUERY` text remains in `final.md` or in the beehiiv draft.
2. **Draft and final match.** Every difference between `draft.md` and `final.md` is either a listed mechanical fix or a suggestion the writer approved in `edit-notes.md`.
3. **Links.** Every link resolves (no 4xx or 5xx) and matches its link text.
4. **Subject line.** About 50 characters or fewer, and honest about what the post contains.
5. **Preview text.** Present, and doesn't repeat the subject line.
6. **Merge tags.** Every merge tag has a fallback, e.g. `{{first_name|there}}`.
7. **Images.** Every image has alt text. The thumbnail is set, or deliberately left out.
8. **Web title.** SEO title is 60 characters or fewer; the description is about 155 or fewer and isn't a copy of the subtitle.
9. **Layout.** The opening, sign-off and any fixed blocks match `voice-and-format`. No leftover template placeholder text.
10. **Disclosure.** The lines above are present where they apply.
11. **Recipients.** The audience is the one intended (default: all free subscribers, email and web).
12. **Send time.** Matches the content calendar, in the publication's time zone.
13. **Test email.** Sent to the writer, with the time recorded.

In paste-in mode (Free plan), items 6, 7, 9, 11 and 13 are checked by the writer in the beehiiv editor after pasting. List them for the writer as a short to-do instead of marking them passed.

## Privacy

- Never put subscriber emails, names or custom-field answers into prompts, files in the repo, or outside tools beyond what the task in hand needs. Reports use counts and percentages.
- Reader replies the writer forwards may be quoted in reports without the reader's name or email.
- Don't quote a reader in a post without the writer confirming the reader agreed.

## Corrections

If a mistake goes out:

1. Tell the writer exactly what was wrong and where, as soon as it's found.
2. Fix the web version. Add a dated correction line at the foot of the post, for example: "Correction, Dec 2: an earlier version said X. It is Y."
3. The subject line and preview text can't be changed after sending.
4. A correction email is the writer's call. Default: mention it at the top of the next post unless the error could cost readers money, time or safety. In that case, send a short correction the writer writes.
5. Record what happened in the post's `qa.md`, and add a check to this document if it would have caught the error.
