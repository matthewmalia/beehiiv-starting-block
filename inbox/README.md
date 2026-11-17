# inbox/ — where every post starts

This folder is the one place you hand writing to the system. Save a finished draft here, run `/submit-draft`, and the editor takes it from there. (You can also paste a draft straight into the chat after the command. Same result.)

```
you write  →  inbox/your-post.md  →  /submit-draft  →  edits you approve  →  test email  →  your yes  →  sent
```

## Bringing an existing newsletter?

`/start` sets beehiiv up around your writing. Drop **3–5 posts you've sent** here, each as its own Markdown or plain-text file (copied from your old platform's editor, an export or a web page), with images next to them, and tell it they're in. Formatting doesn't have to be perfect.

`/start` uses your posts to draft your voice profile. It then asks whether any post should go out again as a first issue on beehiiv. Those stay here and take the first slots on your calendar; the rest are kept as samples in `posts/_samples/`. If your readers are coming with you, they've seen these posts, so samples only is usually right.

A post sent again goes through `/submit-draft` like any other. The editor asks about anything that has gone stale (dates, "last week", links to your old site, "subscribe on …" lines) instead of changing it. Old posts are never rewritten, merged or summarised. Name the files in the order you want them sent (`1-why-small-lists-win.md`, `2-…`), or tell the Publishing Lead.

## Your logo and style guide

Not needed to start. Whenever you're ready, drop your **logo** (PNG or JPG, square works best) or your **style guide** (a PDF, a doc, a screenshot of your newsletter, or a few lines with your colours and fonts) here and tell the Publishing Lead. It moves them to `brand-styles/` and applies them to your post template.

## What to put here

- **One file per post.** Markdown (`.md`) or plain text (`.txt`). Name it anything sensible: `why-small-lists-win.md`.
- **Your own words, complete.** An outline or a list of notes isn't a draft. The editor edits; it doesn't write.
- **Images alongside the draft**, in this folder. PNG or JPG.

## Images

- Name each image for what it shows, lowercase with hyphens: `signup-form-example.png`.
- Refer to it in the draft where it should appear: `![what the image shows](signup-form-example.png)`. The text in the square brackets becomes the alt text; if you leave it empty the editor writes one and shows you.
- To use one as the thumbnail, name it `thumbnail.png` (or `.jpg`), or just tell the editor which.

## Optional notes to the editor

Put anything the editor should know at the very top of the file, above a line of three dashes. It is saved with your draft but never published.

```markdown
edit: light
note: the second section is the one I'm unsure about
---
# Why small lists win

Here's why…
```

For a post you're moving over, `source: migrated` there tells the editor to check for stale references and to default to a light edit.

## What happens to the file

The editor moves your draft and its images into the post's own folder, `posts/<send-date>-<slug>/`, and saves the text there as `draft.md`, exactly as you wrote it. That copy is never changed. The file leaves this folder, so what's still here is always what's waiting.

## Welcome email

When you run `/grow-audience` and choose the welcome email, save it here as `welcome.md`. The prompts are in `templates/welcome-email-prompts.md`.
