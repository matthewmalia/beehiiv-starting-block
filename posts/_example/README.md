# Example post folder

This is a complete sample of what `/submit-draft` and `/weekly-review` leave behind for one post. **Everything in it is fictional**: the writer ("Sam"), the links, the ids and every number. It exists so you can see the shape of each file before your own first post.

Read the files in this order:

| File | Written by | What it shows |
|---|---|---|
| `draft.md` | the writer | The post exactly as submitted, mistakes included. Never changed. |
| `edit-notes.md` | editor | Mechanical fixes made, numbered suggestions, and the writer's decisions |
| `final.md` | editor | The draft plus the fixes plus exactly what the writer accepted |
| `package.yaml` | editor | Headline, subject line and alternatives, SEO, tags, send time, beehiiv ids |
| `assets/` | the writer | Images for the post (here, one placeholder used as the thumbnail) |
| `qa.md` | editor | The pre-send checklist result and the test-email time |
| `performance.md` | analyst | What readers did, added a few days after sending |

Try `diff draft.md final.md`: every changed line traces back to an item in `edit-notes.md`. The pre-send check verifies exactly that.

Real post folders are named `posts/<send-date>-<slug>/`, e.g. `posts/2026-12-01-why-small-lists-win/`. You can delete this folder once you've sent your first post.
