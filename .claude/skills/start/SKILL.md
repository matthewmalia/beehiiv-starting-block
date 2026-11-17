---
name: start
description: The one entry point to Starting Block, for every writer. Sets up beehiiv from what the writer already has (an existing newsletter on beehiiv or another platform - 3-5 posts dropped in inbox/) or, for a first newsletter, from the name and promise. Both get a look (kept from beehiiv or one of three presets), three beehiiv categories, and the post template. Introduces the Publishing Lead, editor and analyst, fixes the send slot, plans the first four weeks and lines up the first post. Safe to run again; it skips what is already done.
disable-model-invocation: true
---

# /start

Every writer starts here, once. The goal is **speed to the first send**: by the end, beehiiv is set up in the writer's look, there's a four-week calendar, and there's one clear next action.

There are two branches. **Already publishing** is the main one (our writers are mostly experienced) and is listed first whenever you offer the choice. **First newsletter** is the short path for someone with no publishing history.

Ask one question at a time and skip any whose answer already exists. Before each step, check whether it's already done. Don't bring up the welcome email, forms, referrals, recommendations or surveys: they belong to `/grow-audience`. Don't ask for a logo, style guide or brand colours either: the writer can send them any time after `/start` (see "Brand style" in `CLAUDE.md`).

**How to ask.** Every question marked **Ask with `AskUserQuestion`** below has set answers: use that tool with the header, question and options given, as in "Tone with the writer" in `CLAUDE.md`. The tool adds an "Other" option for anything else. Questions marked **Ask in plain text** are open-ended (a name, a sentence, what to write about): ask them in your message and let the writer type.

**Change nothing the writer has already built in beehiiv.** Where something exists (template, theme, skills, name, description, categories), keep it, or work on a copy, and say so in one line.

## 0. Preflight

1. `get_workspace` → `plan` and `created_at`. `list_publications` → the publication. `get_publication` and `get_publication_settings` → name, description, logo, time zone, categories (`general_info.tags`).
   - More than one publication: **Ask with `AskUserQuestion`**: header "Newsletter", question "Which newsletter are we setting up?", one option per publication name (up to four; with more, list them in plain text and ask the writer to name one).
2. **Mode**, as in "Modes" in `CLAUDE.md`. On `plan: "Free"` run the write check, because the Pro trial also reports Free.
   - Write accepted on Free: full mode. Say in one line it looks like the Pro trial, with the estimated end date, and that the plan decision is due before then.
   - Write rejected: paste-in mode. **Ask with `AskUserQuestion`**: header "beehiiv plan", question "On beehiiv's Free plan I can't build things in your account. Start the free 14-day Pro trial (no card needed) so I can?", options **Start the trial** ("Start it in the beehiiv app, then pick this; I'll check again") / **Continue with files** ("I'll prepare everything as files and list what to set by hand in the app"). On the first, run the write check again and update `access`.
3. `get_current_user` → the test-email address and the writer's name.
4. `list_posts` (sent), `list_post_templates`, `list_skills`. If there are sent posts, work out from the last 20: the usual send day and time, how many of the last 8 weeks had a send, and the longest gap.
5. If `config/publication.yaml` doesn't exist, copy `config/publication.example.yaml` to it. Fill in `publication_id`, `writer_name`, `test_email`, the time zone and the `access` block.

## 1. Which branch

If beehiiv already has sent posts, the branch is **already publishing**: don't ask, just say what you found in one line (*"<Name>: <n> posts sent since <date>, usually <day> around <time>, <n> of the last 8 weeks."*).

Otherwise **Ask with `AskUserQuestion`**: header "Your path", question "Are you already publishing a newsletter, on beehiiv or another platform, or is this your first?", options:

- **Already publishing**: "Bring a few posts you've sent, and I'll set beehiiv up around your writing."
- **My first newsletter**: "Pick a look and start writing."

Save `setup.branch: existing` or `first`.

## 2. Meet the team (both branches)

Say this once, in your own words, in about four lines:

> **You write and decide; I run the rest.** I'm your **Publishing Lead**: I plan the calendar with you, remind you before drafts are due, and coordinate everything up to the send, which always waits for your yes. The **editor** turns your draft into a ready-to-send newsletter: fixes, suggested edits you accept or reject, headline and subject line options, the beehiiv build, checks and a test email. It never writes for you. The **analyst** reads your numbers and your readers' replies after each send and suggests one or two things to try, so the newsletter grows in the direction readers respond to.

## 3a. Already publishing: bring your posts

**On beehiiv already:** the material is there. Read the template and its theme, the name and description, and pull 3–5 recent sent posts with `get_post_content(format: "text")` as voice samples.

**From another platform:** say in one line: *"Drop 3–5 posts you've sent in the `inbox/` folder, each as its own Markdown or plain-text file with images next to it."* Then **Ask with `AskUserQuestion`**: header "Your posts", question "Are your posts in the inbox/ folder?", options **They're in inbox/** / **I don't have posts** ("We'll carry on without them"). On the first, check the folder; if it's empty, say so and ask again.

When they arrive:

1. List what you see. If a logo or style guide arrives too, move it to `brand-styles/` (`logo.<ext>`, `style-guide.<ext>`), say in one line that you'll apply it once setup is done, and do that at the end of step 10 as in "Brand style" in `CLAUDE.md`. Ask only about a file you can't place.
2. **Ask with `AskUserQuestion`**: header "Old posts", question "Should any of these posts go out again as your first issues on beehiiv, or are they just samples of your writing?", options **Samples only** ("Best if your readers are coming with you: they've seen these posts") / **Send some as first issues**.
   - **First issues:** leave them in `inbox/`; they go out in filename order unless the writer says otherwise. They go through `/submit-draft` like any post (`source: migrated`). Then **Ask with `AskUserQuestion`**: header "Original date", question "Add a 'First published on …' line to these posts?", options **Yes, add a line** / **No line**. On a yes, **ask in plain text** for the wording and record it as `migration.note_original`; never add it yourself.
   - **Samples:** move them to `posts/_samples/` unchanged.

`inbox/` keeps only posts waiting to be sent.

**Name and promise:** as in 3b below. If their posts already state the one-sentence promise, quote it and **Ask with `AskUserQuestion`**: header "Promise", question "Use this sentence as the line that tells readers what they'll get?", options **Use this sentence** / **Write my own** (then **ask in plain text**).

## 3b. Name and promise

Ask only for what isn't set in beehiiv. Their words, not yours. Don't polish them.

- **Name set in beehiiv:** **Ask with `AskUserQuestion`**: header "Name", question "Keep \"<name>\" as your newsletter's name?", options **Keep "<name>"** / **Rename it** (then **ask in plain text** for the new name).
- **No name:** **Ask in plain text**: *"What's the newsletter called?"*
- **Promise** (unless 3a settled it): **Ask in plain text**: *"What's the one sentence that tells a reader what they'll get?"*

Both branches: save the sentence as `promise` in the config, and `save_publication_settings` for anything new (in paste-in mode, put it on the writer's app to-do list instead).

## 4. The look

One decision, for both branches:

- **On beehiiv with a template they use:** keep their look. Say so in one line. `brand.style: existing`. No question.
- **Everyone else:** **Ask with `AskUserQuestion`**: header "Look", question "Pick a look for your newsletter. To see all three side by side, open brand-styles/preview.html in your browser. Your own colours, fonts or logo can come any time later.", options:
  - **Clean (Recommended)**: "Modern and quiet. White page, Inter, a blue accent."
  - **Editorial**: "Reads like a magazine column. Serif type on warm paper, deep red accent."
  - **Bold**: "High contrast. Big headings, white card on dark navy, orange accent."

Read `brand-styles/<id>.json`. No answer: Clean, and say so. Save `brand.style`. If the writer uses "Other" to ask for their own colours, start from the nearest preset and follow "Your own style" in `brand-styles/README.md`.

## 5. Categories (no questions)

beehiiv lets a publication choose three **categories** from a fixed list. Readers never see them, but beehiiv uses them to decide who finds the newsletter: recommendation matching with other newsletters, beehiiv's discovery pages, and ad-network matching with sponsors.

- **Three already set** in `get_publication_settings`: keep them. Say so in one line (*"Your beehiiv categories: writing, marketing, business. Kept."*). No explanation needed.
- **One or two set:** keep those and choose the rest as below.
- **None set:** choose three.

To choose: `list_publication_tags`, then pick the names that best fit the promise, the name and description, and any posts. Use the exact spelling from the list, and always fill all three slots. Don't ask; announce the choice with a short explanation, in about three lines:

> **Your beehiiv categories: writing, marketing, business.**
> beehiiv uses these three categories to decide where your newsletter shows up beyond your own list: in other writers' recommendations after someone subscribes to them, in beehiiv's discovery pages, and in the ad network's matching with sponsors. Readers never see them. They decide who finds you. I picked these from your description. Tell me any time to change them; there are about 120 to choose from.

If the writer names one that isn't on the list, propose the closest that is.

Save: `save_publication_settings` with `settings.general_info.tags` set to all three names (the field replaces the whole set). In paste-in mode, put "set your categories to …" on the writer's app to-do list instead. Both modes: record the names as `publication_tags` in the config. These are not content tags.

## 6. The voice

**Already publishing, with 3 or more posts** (samples, first issues or beehiiv posts): draft their voice profile from the posts alone, following step 2 and steps 4.1–4.2 of `.claude/skills/capture-voice/SKILL.md` (the upload happens in step 7 below). Skip that routine's questions. Leave the reader section as the starter has it ("use the publication's description"). Show the complete profile, then **Ask with `AskUserQuestion`**: header "Voice", question "Does this profile describe how you write?", options **Looks right** / **Change something** (then **ask in plain text** what to change, revise, and ask again). On approval set `voice.captured: true`. This replaces the neutral starter.

If they already have a voice or style skill in beehiiv (`list_skills`), keep it: record its id as `skills.voice_and_format_id` and skip the draft.

**First newsletter,** or fewer than 3 posts: use the neutral starter. Say in one line that `/capture-voice` tailors it after two or three posts.

## 7. Build (no questions)

Do these without stopping and report them together in a few lines.

1. **Post template.** Delegate to the `editor`:
   - a template they already use → copy it ("<name> (Starting Block)") and add the body placeholder, as in the editor's one-time setup work;
   - otherwise → create "Starting Block" from `templates/post-skeleton.html` and apply the style with `save_post_template_theme`.
   Save `post_template_id`.
2. **Skills.** Upload the voice profile (or the starter) and `beehiiv-skills/publishing-standards.md` with `save_skill`, unless an equivalent exists. If `workspace` visibility is rejected, save as `private`. Save both ids. Keep `beehiiv-skills/voice-and-format.md` in the repo the same as what was uploaded.

**Paste-in mode:** skip the beehiiv writes. Give the writer the fonts and colours to set by hand in beehiiv's post design settings. Leave the skill ids empty: the editor and analyst read the guides from `beehiiv-skills/` in the repo. Say that in one line.

If a write is rejected for plan reasons even though the write check passed, switch to paste-in for the rest of the build, as in `CLAUDE.md`.

## 8. Send slot

- **On beehiiv already, with a pattern:** **Ask with `AskUserQuestion`**: header "Send slot", question "Keep <day> at <time> (<time zone>) as your weekly send slot?", options **Keep <day> <time>** / **Change it** (then ask as below).
- **Everyone else:** **Ask with `AskUserQuestion`**, two questions in one call:
  - header "Send day", question "Which day will you send each week?" (from another platform: "Which day do you send now? Keeping your readers' rhythm is usually best."), options **Tuesday** / **Wednesday** / **Thursday**.
  - header "Send time", question "What time? (<time zone>)", options **7:00 am** / **8:00 am** / **9:00 am**.

  Any other day or time comes through "Other".

The time zone is the one you found; don't ask about it unless it looks wrong. Save to the config. The draft is due 2 days before at 6pm: mention it, don't ask.

## 9. How drafts reach me, and the first calendar

Say in two lines:

> When a post is ready, save it as a Markdown or plain-text file in `inbox/` (images next to it), or paste it into the chat, and run `/submit-draft`. `inbox/README.md` has the details. It takes finished drafts in your own words, not outlines.

Then go straight into the `/plan-content` routine for the next **4 weeks** (read `.claude/skills/plan-content/SKILL.md` and follow it). Posts in `inbox/` take the first slots. For writers already on beehiiv, add their recent sends to the calendar as history (`sent`, noted `before Starting Block`); the streak starts with the first slot planned here.

## 10. Hand over

Set `setup.completed_on`. End with:

1. The status line: next send, draft due date, inbox count.
2. **One next action**, and only one:
   - a post waiting in `inbox/`: *"Run `/submit-draft` and I'll take your first issue through."*
   - otherwise: *"Write your first post by <due date>, save it in `inbox/` or paste it here, and run `/submit-draft`."*
3. Two lines on what's set up: name, send slot, look, categories (with a few words on what they do: *"categories: writing, marketing, business (how beehiiv recommends you)"*), template, voice (profile or starter), calendar.
4. First newsletter only, one line: *"After two or three posts, `/capture-voice` teaches the editor your style."* (`/grow-audience` is suggested later, as in `CLAUDE.md`.)
5. If `access.trial` is `likely` and the estimated end falls before the first send, say so in one line: after that, posts are prepared for pasting into beehiiv unless they choose a paid plan.
6. Only what applies: *"Yours to do in the beehiiv app: <custom domain, importing your subscribers, setting your categories (paste-in), …>."*
7. If a logo or style guide arrived in step 3a: apply it now as in "Brand style" in `CLAUDE.md`, and report it in one line.

Stop there.
