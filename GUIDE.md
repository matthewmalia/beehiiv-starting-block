# Starting Block for beehiiv Publishing

### You write it. AI handles the publishing. A beehiiv + Claude playbook for getting started fast and staying consistent

> **What this is:** the background to the toolkit: why it's built this way, what the beehiiv MCP can and can't do, how the pieces fit, and how to keep the weekly habit. To get going, read [README.md](README.md). The step-by-step behaviour lives in the files that run it (see [§7](#7-where-the-details-live)), so this guide doesn't repeat it.
>
> **The deal:** **You write every post.** AI handles the rest: planning, editing and preparing your draft, building it in beehiiv, checking it before it goes out, and reporting back on how readers responded.
>
> **The goal:** Your first post is on the calendar by the end of your first session. By day 30 you've sent at least four posts on the same day and time, and you get a weekly report showing what's working with your readers.
>
> **Checked against:** The live beehiiv MCP tools, beehiiv's built-in agent skills, and beehiiv's help center in **November 2026**. beehiiv updates its MCP faster than its help articles. When the two disagree, go by the tool list in your AI tool (see [§2.5](#25-watchouts-that-are-helpful-to-know-going-in)).

---

## Contents

1. [Why consistency](#1-why-consistency)
2. [The beehiiv MCP, evaluated](#2-the-beehiiv-mcp-evaluated)
3. [System architecture](#3-system-architecture)
4. [Habit and running jobs on a schedule](#4-habit-and-running-jobs-on-a-schedule)
5. [Guardrails, privacy and deliverability](#5-guardrails-privacy-and-deliverability)
6. [Prompt cookbook](#6-prompt-cookbook)
7. [Where the details live](#7-where-the-details-live)
8. [Your first 30 days](#8-your-first-30-days)
9. [What's next](#9-whats-next)
10. [Appendix](#10-appendix)

---

## 1. Why consistency

New newsletters fail when posts stop going out. Establishing a regular schedule in your first 30 days sets you up for success. That shapes everything here: getting started is kept short so the first post goes out sooner, and everything that isn't needed for that first send waits.

| What often stops writers | What the system takes off your plate |
|---|---|
| "What should I write about this week?" | A content calendar you and the Publishing Lead plan together, plus a list of ideas (`/plan-content`) |
| Losing track of time until the night before sending | Draft due dates and reminders, with the send day fixed in advance ([§4](#4-habit-and-running-jobs-on-a-schedule)) |
| The work between "done writing" and "sent" | The editor handles copyediting, formatting, headline and subject lines, images, SEO, link checks, the beehiiv build and the test email (`/submit-draft`) |
| "Is anyone reading this?" | The analyst's weekly report, in plain language, compared with your own averages (`/weekly-review`) |

Who does what is in [README.md](README.md#who-does-what). beehiiv's MCP enforces most of those limits on its own:

| beehiiv guardrail | What it means for the system |
|---|---|
| `save_post` only creates **drafts**. Publishing is always done by a person. | The editor can get a post ready to send but can't send it. |
| `schedule_post` needs **Pro** (or the trial) and a send time **at least 10 minutes away**, and it returns an `editor_url`. | Even scheduled sends leave you time to review or cancel. |
| Automations are built as drafts and must be **turned on in the beehiiv app**. | Your welcome email doesn't reach anyone until you turn it on. |
| The MCP has the **same permissions as your beehiiv account role**. | It can't do anything your role can't. |

### Plans and what the MCP can do

| Plan | What the MCP can do | Subscriber limit | How the system works |
|---|---|---|---|
| **Free** | Read only: answers questions and reviews your data | 2,500 | **Paste-in mode.** The editor writes a finished, formatted `final.md` and the post details. You paste it into the beehiiv editor and schedule it. Your voice and standards guides stay in the repo. The analyst still reads your live stats. |
| **14-day Pro trial** | Pro features, including scheduling and sending through the MCP | Free-plan limits apply (e.g. 1 post a day) | **Full mode.** Use it for getting started and your first two posts. Automations you build during the trial switch off afterwards unless you upgrade. |
| **Lite** | Creates and edits drafts, templates, forms, segments and automations | 100,000 | **Full mode.** You schedule in the beehiiv app, which takes about two minutes. |
| **Pro** | Everything in Lite, plus scheduling and sending through the MCP | 250,000 | **Full mode**, and scheduling can happen from Claude after you say yes. |

**The trial reports itself as Free.** During the Pro trial, `get_workspace` still returns `plan: "Free"` and says nothing about the trial, yet writes work. So the Publishing Lead never picks the mode from the plan name alone: on Free it makes one no-op save (the publication name, unchanged) and goes by whether beehiiv accepts it. The result, and an estimated trial end (workspace creation date + 14 days), are kept under `access` in `config/publication.yaml`. Details: "Modes" in [CLAUDE.md](CLAUDE.md).

> **Recommendation:** Start on the Pro trial. By day 14, choose Lite so that the editor keeps building posts in beehiiv for you.

---

## 2. The beehiiv MCP, evaluated

The beehiiv MCP is a remote server that you sign in to through your browser (OAuth). It has **more than 200 tools**, and they follow a consistent naming pattern: `save_*` creates or updates something (leave out the id to create), `get_*` and `list_*` read, and `learn_*` returns the exact format a write tool accepts.

### 2.1 Capability map (publishing-relevant)

| Area | Key tools | What the system uses it for |
|---|---|---|
| **Account** | `get_current_user`, `get_workspace`, `list_publications`, `get_publication`, `get_publication_settings`, `save_publication_settings` | Checking your plan (`get_workspace` → `plan`) to pick full or paste-in mode, finding publication IDs, setting your description and tags. Always the first calls in a session. |
| **Building posts** | `learn_post_authoring`, `learn_post_metadata`, `save_post`, `edit_post`, `edit_post_content`, `get_post_content`, `list_posts`, `get_post` | Turning your final text into native beehiiv editor blocks; setting the title, subtitle, SEO, email settings and tags. |
| **Templates and design** | `list_post_templates`, `save_post_template`, `duplicate_post_template`, `edit_post_template_content`, `save_post_template_theme`, `get_post_theme`, `save_post_theme`, `save_post_footer` | A fixed post layout and consistent branding, so each post just needs your words placed into it. `save_post_template_theme` styles every post built from the template; `save_post_theme` changes one post only. |
| **Sending** | `send_test_email`, `save_split_test`, `schedule_post` (Pro) | A test email to you, subject-line A/B tests, and scheduled sends you can cancel. |
| **Images** | `save_image` (from a URL or base64, so files from your repo work), `generate_image`, `get_image_generation_status`, `list_assets` | Uploading your own images; making a thumbnail only if you allow it. |
| **Reader signals** | `list_post_clicks`, `list_poll_responses`, `list_survey_responses`, `save_poll`, `save_survey` | The analyst's raw material: what readers clicked, voted on and told you. |
| **Audience setup** | `save_subscribe_form`, `learn_subscribe_form_authoring`, `save_referral_program`, `discover_publications`, `list_recommendation_suggestions`, `save_recommendation`, `save_custom_field`, `save_segment` | Signup forms, referrals, recommendations with similar newsletters, and simple segments. Left out of getting started; set up later with `/grow-audience`. |
| **Automations** | `get_automation_schema`, `save_automation`, `save_automation_email`, `get_automation_stats` | Your welcome email (which you write), set up later with `/grow-audience`. |
| **Analytics** | `get_publication_stats`, `get_post_stats`, `get_post_stats_batch`, `get_subscriber_growth`, `get_subscriber_history`, `get_post_isp_breakdown`, `get_website_analytics`, `get_website_analytics_breakdown` | Everything in the analyst's weekly report. |
| **Skills** | `list_skills`, `get_skill`, `save_skill` | Shared instructions that beehiiv's in-app Agent and your own agents both read ([§2.3](#23-beehiivs-built-in-agent-skills-reuse-dont-rebuild)). |
| **Docs** | `search_documentation`, `read_documentation` | Looking up beehiiv's help center before acting. |

The MCP also covers monetization, podcasts, community and the website builder. This guide leaves those out on purpose.

### 2.2 How beehiiv posts are built (the editor needs this)

beehiiv posts are stored as structured editor documents, not raw HTML. `save_post` converts HTML into native editor blocks and silently drops anything it doesn't recognize. So:

- **Call `learn_post_authoring` first**, once per publication each session. It returns every supported block with example HTML, your publication's **merge tags** (`{{first_name|there}}`, `{{rp_refer_url}}`, `{{subscriber_preferences_url}}`), your theme defaults, and an `available` flag for blocks that depend on your plan.
- **Blocks the editor uses to format your writing:** headings, paragraphs, lists, block quotes and pull quotes (`blockquoteFigure`), `imageBlock` (`<figure data-type="imageBlock" data-src="…">`), `button`, `section` (a styled card; all styling goes in `data-*` attributes because inline `style` is dropped), `columns`, `genericEmbed` (link preview card), `poll`, `referralProgram`, `recommendation`, `subscriberBreak`, `tableOfContents`.
- **Not available through the MCP** (you must add these in the editor): footnotes, dynamic content, and the AI writer and image widgets.
- **Editing safely:** read the post with `get_post_content(format: "editor_html")`, then change specific blocks with `edit_post_content`, identifying each block by its `data-node-hash`. If you changed that block in the beehiiv editor since it was read, the edit is rejected and **nothing** is applied, so the editor reads the post again. You and the editor can both touch a draft without overwriting each other's work.
- **Templates:** content you send with `html_content` is placed *after* the template's content, so it lands below the sign-off. Instead, create the post from the template with no `html_content`, then `replace` the template's placeholder paragraph using `edit_post_content`. (Keep the placeholder a plain paragraph: replacing a `section` means sending all of its attributes back.)
- **Themes:** fonts, colors, spacing and button styles are theme tokens, not HTML. Font names must come from beehiiv's font list (`learn_post_authoring` with `node: "textStyle"`); a font that isn't on it is dropped without an error. The three Starting Block brand styles are sets of these tokens ([brand-styles/README.md](brand-styles/README.md)).

### 2.3 beehiiv's built-in agent skills: reuse, don't rebuild

beehiiv has ten **built-in skills** (`list_skills`, `get_skill`). The toolkit loads four of them:

| Skill id | What it does | Used by |
|---|---|---|
| `repo_skill:edit-post` | Edits in **the publication's own voice** and changes only what's needed, so the writer's sentences stay. Lists every change and old and new word counts. | editor |
| `repo_skill:performance-report` | Compares each post with your own averages (open rate for subject lines, click rate for content) and spots patterns | analyst |
| `repo_skill:unsubscribe-spikes` | Finds unusual unsubscribe days and links each one to the post that likely caused it | analyst |
| `repo_skill:automation-dropoff` | Shows where readers lose interest in your welcome email(s) | analyst |

`repo_skill:edit-post` sets the right default for this guide: it changes only what you ask for and leaves your strong paragraphs alone. Two others, `repo_skill:start-here` (recommends one task to do first) and `repo_skill:onboarding` (checks your setup against a checklist), aren't used by the toolkit but are handy from beehiiv's in-app Agent or the prompt cookbook ([§6](#6-prompt-cookbook)).

The skills you add yourself with `save_skill` (Markdown, up to 10,000 characters, `private` or `workspace` visibility) sit alongside these. Your voice and standards belong here, so **beehiiv's in-app Agent (⌘J) follows them too**, not only your Claude setup.

### 2.4 beehiiv Agent vs. the beehiiv MCP

- **beehiiv Agent** is the assistant built into the beehiiv app (⌘J / Ctrl+J). It knows your publication, and per beehiiv's docs it can do everything the MCP can do. It's handy for quick fixes while you're working in the editor.
- **The beehiiv MCP** brings the same abilities into an *outside* AI tool (Claude, Claude Code, Cursor, Codex), where you can add your own files (your drafts, your notes), version control and schedules. **This playbook runs on the MCP** and stores your voice as beehiiv skills, so both tools behave the same way.

### 2.5 Watchouts that are helpful to know going in

1. **The docs lag behind the tools.** Some help articles describe areas as read-only that the live MCP can now change. Trust the tool list and the `learn_*` `available` flags. In Claude, use **Refresh tools list** when beehiiv adds tools.
2. **IDs have prefixes** (`pub_`, `post_`, `aut_`, `poll_`, `nl_list_`). Always use the IDs that list tools return. A few blocks take plain UUIDs (recommendations, RSS feeds), so check each block's note in `learn_post_authoring`.
3. **Image generation runs in the background and uses AI credits.** If you allow generated thumbnails, start the job early and collect it with `get_image_generation_status`. Your own images upload instantly with `save_image`.
4. **Automation edits are saved as drafts.** `save_automation` can replace an automation only if it has never been published. For live automations, use the `add_`/`update_`/`delete_automation_step` tools, then publish from the beehiiv app.
5. **`wait_until` steps can send two emails on the same day.** Watch for `same_day_send` warnings, and add a `wait_for` of at least 86,400 seconds (24 hours) when you want a full day between emails.
6. **Subject line and preview text lock once a post is sent.** `edit_post` rejects changes to them after sending, so get them right in the package.
7. **Some steps only work in the beehiiv app:** custom domain, custom sending domain, importing subscribers, turning on automations, sending tests to addresses outside your workspace (on the trial), and sending posts (on Free and Lite).

---

## 3. System architecture

```
          ┌──────────────────────────────────────────────────────────────┐
          │                     YOU: the writer                          │
          │  write every post · accept/reject edits · approve the send   │
          └───────┬───────────────────────────────▲──────────────────────┘
     paste draft  │  or save to inbox/            │ edit notes · test email · weekly report
┌─────────────────▼───────────────────────────────┴──────────────────────────┐
│  Claude Code project (a git repo)                                          │
│                                                                            │
│  CLAUDE.md ── Publishing Lead (main session: plans with you, prompts for   │
│               drafts, coordinates, schedules only on your "yes")           │
│      ├── editor   intake → posts/<date>-<slug>/ → edit → package → build   │
│      │            → check → test email                                     │
│      └── analyst  numbers → posts/<…>/performance.md → weekly report       │
│                                                                            │
│  .claude/skills/  begin:  /start (already publishing · first newsletter)   │
│                   weekly: /plan-content  /submit-draft  /weekly-review     │
│                   later:  /capture-voice  /grow-audience                   │
│  inbox/   ← drop drafts here          posts/   ← one folder per post       │
│  ops/     content-calendar.md · ideas.md · learnings.md · replies.md       │
│  brand-styles/  clean · editorial · bold      .mcp.json ── beehiiv MCP     │
└───────────────────────────────────────┬────────────────────────────────────┘
                                        │ MCP (OAuth, your role's permissions)
┌───────────────────────────────────────▼────────────────────────────────────┐
│  beehiiv workspace                                                         │
│  Your skills: voice-and-format · publishing-standards (+ beehiiv built-ins)│
│  Publication: posts · template + theme · analytics                         │
│               (later: welcome email · forms · referrals · recommendations) │
└────────────────────────────────────────────────────────────────────────────┘
```

**Six design principles:**

1. **You're the writer.** You signed up for a newsletter publishing platform. Writing is required, not replaced by AI (in this repo), and your audience prefers your writing. The editor fixes only mechanical errors on its own (spelling, grammar, punctuation, house style) and lists each one. Anything that changes meaning, structure or tone is a numbered suggestion you accept or reject.
2. **One folder per post.** Every submission gets its own folder, `posts/<date>-<slug>/`, holding everything from your original draft to the final version, the publishing details, the pre-send check, and later the performance results. Six months in, you have a searchable history of what you wrote and how readers responded.
3. **The plan lives in files.** The calendar (which doubles as the publishing history), ideas list and lessons are plain Markdown in the repo, so any session can pick up where the last one stopped. The beehiiv workspace is the source of truth if data between the file and the platform disagree. Consider beehiiv system of record for what was sent, when it was sent, and the related analytics.
4. **Your voice lives in beehiiv.** `voice-and-format` describes how *you* write, so the editor protects it rather than overwriting it, and beehiiv's in-app Agent follows the same rules.
5. **Data comes back to you as advice, not edits.** The analyst never changes your drafts. It tells you what readers responded to, and you decide what to do with that.
6. **First send first.** One `/start` for everyone, with no open-ended questions. A writer who's already publishing brings their posts instead of answering questions about their voice; everyone else picks a preset look. A logo, style guide or brand colours can come any time later. Anything that isn't needed to send post one (forms, the welcome email, referrals, recommendations) has its own skill and waits until you're publishing. Until a voice profile exists, the editor works from a neutral starter whose main rule is that your draft is the style guide.

### 3.1 Connecting the MCP

**Claude Code (what this repo is built for):** The repo's `.mcp.json` already points at `https://mcp.beehiiv.com/mcp`. Open the repo with `claude`, approve the server when asked, then run `/mcp`, choose **beehiiv** and sign in through your browser.

**Claude (web or desktop):** Go to **Customize > Connectors** and find and connect beehiiv. Alternatively, from your beehiiv workspace, go to **Settings → MCP** and follow the setup guide. The slash commands and agents need Claude Code; in the app, the prompt cookbook in [§6](#6-prompt-cookbook) covers the same ground by hand.

---

## 4. Habit and running jobs on a schedule

1. **Same day, same time, same template.** Make writing a habit, so your audience reads as a habit.
2. **The draft is due 2 days before sending.** That gives the editor and you time to go back and forth without rushing.
3. **One article a week.** `/plan-content` gives every week a working title in your words, so you never start from a blank page.
4. **Use the short format in heavy weeks.** About 200 words, one idea, defined in `voice-and-format`. A short post on time beats a long post late.
5. **Watch the streak.** `ops/content-calendar.md` records each send against its planned time. If no draft has arrived 24 hours before the due date, the Lead checks in and offers two options: *submit what you have* or *write a short post*. It never writes a post for you.
6. **Track your overhead.** If approving edits regularly takes more than 15 minutes, tell the editor what you keep rejecting. That becomes a rule in `voice-and-format`, and the next round of suggestions gets better.

### Running jobs on a schedule

| Job | When | Unattended? |
|---|---|---|
| Draft-due reminder | 2 days before the due date, then on the due date | Yes (a message to you) |
| Edit and package | When you submit | Starts when you submit; waits for your decisions |
| Pre-send check and test email | After packaging | Yes |
| Schedule the send | — | **No.** Always your yes. |
| Weekly review | 3 days after each send | Yes (reports and suggestions only) |

- **Claude scheduled tasks:** a recurring task that sends you the reminder ("Draft due Sunday: *[title]*") and runs `/weekly-review`.
- **Cron + Claude Code without a person present:** [`scripts/weekly-run.sh`](scripts/weekly-run.sh) wraps this: `claude -p "/weekly-review" --output-format json`. Slash-command skills work in `-p` mode. Pre-approve only the tools the job needs with `--allowedTools`, and never include `mcp__beehiiv__schedule_post`.
- **Sign-in caveat:** the beehiiv MCP signs in through your browser (OAuth). Run scheduled jobs on a machine where the connection is already signed in (open Claude Code in the repo, run `/mcp` and authenticate beehiiv), and test that the sign-in persists. For fully automated pipelines, beehiiv points developers to its **versioned REST API**.

---

## 5. Guardrails, privacy and deliverability

**Always done or approved by you:**
- Writing every post and the welcome email.
- Accepting or rejecting each suggested edit.
- Choosing the headline and subject line.
- Scheduling or sending any post, and turning on any automation.
- Changes to your voice and standards skills.

**What the editor holds itself to:**
- **Your words stay yours.** `draft.md` is never changed. Any difference between `draft.md` and `final.md` has to be either a listed mechanical fix or a suggestion you approved, and the pre-send check verifies this.
- **Nothing gets added.** No new claims, examples, quotes or statistics. Gaps become `[QUERY]`.
- **Check, don't assume.** Every link is checked, and every statistic is linked or flagged.
- **Disclosure** follows your `publishing-standards`. If you're a brand, that includes how you mention your own products.

**What the analyst holds itself to:**
- Uses only your own numbers, compares only with your own averages, and states the date range.
- Never presents a projection as fact, and never calls something a pattern from a single post.
- Gives advice, not edits. You decide what to change.

**Data and privacy:**
- The MCP can see subscriber emails and any custom fields you collect, and you're responsible for how connected AI tools use them. Give each agent only the tools it needs, and don't paste subscriber lists into outside tools.
- Brand teams: Connect the MCP through a dedicated beehiiv seat with the narrowest role that works, so every action can be traced.

**Deliverability basics:** Send on a steady schedule, invite replies, and check `get_post_isp_breakdown` if open rates drop at one email provider (for example, only Gmail).

---

## 6. Prompt cookbook

Use these in Claude with the beehiiv MCP connected, or as starting points for your own routines.

1. **Where am I?** "Run beehiiv's start-here skill for my publication and tell me the one thing to do first, using my numbers."
2. **Bring my old posts:** "I've saved three posts from my old blog in inbox/. Line them up as my first three sends, in filename order."
3. **Change my look:** "Switch my brand style to Editorial." / "Keep Clean, but make the accent `#0A7C66`."
4. **Capture my voice:** "/capture-voice" (or, by hand: "Here are 3 things I've written [paste or point to files]. Draft a `voice-and-format` skill describing how *I* write, including quirks an editor shouldn't 'fix'. Show it to me before saving.")
5. **Plan together:** "Let's plan the next 6 weeks. Ask me your questions one at a time, then propose a calendar with draft due dates."
6. **Submit (pasted):** "/submit-draft light" followed by your draft pasted below it.
7. **Submit (file):** "My draft is in inbox/why-small-lists-win.md with two images. /submit-draft"
8. **Decide on edits:** "Accept 1, 3 and 5. Reject 2. For 4, use: 'Start with the form, then share it everywhere.'"
9. **Deep edit first:** "/submit-draft deep. I'm not sure the structure works. Give me notes only; I'll revise and resubmit."
10. **Headline options:** "Give me 3 headlines and 3 subject lines for this post in the style of my best-opened posts. I'll choose."
11. **Revise:** "Here's v2 after your notes [paste]. Compare it with the original and rebuild the post."
12. **Late week:** "I won't finish this week's draft. What are my options?" (The Lead offers to take what you have, or a short post.)
13. **How did it do?** "Run the analyst on my last post and tell me 2 things to try in my next draft."
14. **Why did people leave?** "Run unsubscribe-spikes for the last 30 days and show me the post behind each spike."
15. **Reader replies:** "Here are 4 replies I got this week [paste]. Add them to this week's report and suggest ideas from them."

---

## 7. Where the details live

Each routine is written down once, in the file that runs it. Read these for the exact behaviour:

| Topic | File |
|---|---|
| The Publishing Lead: session start, modes, rules, scheduling, late drafts | [`CLAUDE.md`](CLAUDE.md) |
| The editor: intake, edit levels, packaging, the beehiiv build, conversion notes | [`.claude/agents/editor.md`](.claude/agents/editor.md) |
| The analyst: what it reads, how it compares, lessons | [`.claude/agents/analyst.md`](.claude/agents/analyst.md) |
| Getting started | [`/start`](.claude/skills/start/SKILL.md) |
| The weekly loop | [`/plan-content`](.claude/skills/plan-content/SKILL.md) · [`/submit-draft`](.claude/skills/submit-draft/SKILL.md) · [`/weekly-review`](.claude/skills/weekly-review/SKILL.md) |
| Later | [`/capture-voice`](.claude/skills/capture-voice/SKILL.md) · [`/grow-audience`](.claude/skills/grow-audience/SKILL.md) |
| Your voice and the pre-send checklist | [`beehiiv-skills/`](beehiiv-skills/) (uploaded to beehiiv when your plan allows) |
| What a finished post folder looks like | [`posts/_example/`](posts/_example/) |
| How drafts reach the system | [`inbox/README.md`](inbox/README.md) |
| Brand styles | [`brand-styles/README.md`](brand-styles/README.md) |
| The repo layout | [README.md](README.md#whats-in-the-repo) |

---

## 8. Your first 30 days

| Days | Focus | Run | You do | Done when |
|---|---|---|---|---|
| **1** | **Start** | `/start` | Already publishing: drop 3–5 posts in `inbox/` and approve your voice profile. Both: pick a look (or keep yours), see your three beehiiv categories, fix your send slot and plan four weeks. | Template in your look; 4-week calendar; you know your next action |
| **2–7** | **Post #1** | `/submit-draft` | Submit your first post (an old one from `inbox/`, or a new one). Decide on edits, approve, schedule. Share the link on your other channels. | Post #1 sent on your send day; its folder complete |
| **8–14** | **Post #2** | `/submit-draft`, `/weekly-review` | Send post #2. Read your first report. **Decide by day 14: Free or Lite.** | Post #2 sent; first report read |
| **15–21** | **Post #3 + your voice** | `/submit-draft`, `/weekly-review`, `/capture-voice` (first newsletter) | Try one of the analyst's suggestions in your draft. First newsletter: approve your voice profile. | Post #3 sent; voice profile saved |
| **22–30** | **Post #4 + month 2** | `/submit-draft`, `/weekly-review`, `/plan-content 4`, `/grow-audience` | Plan month 2 with the Lead, using what the reports showed. Write your welcome email. | Post #4 sent; month 2 planned; welcome email switched on |

**Day-30 success criteria:**
- ✅ **4 posts sent on the same day and time**, each with a complete folder (`draft.md` → `final.md` → `performance.md`)
- ✅ **Voice profile captured**, and a welcome email written by you and switched on
- ✅ **At least 1 lesson, backed by results,** in your voice skill
- ✅ Weekly time spent on everything except writing: **30 minutes or less**

Forms, the signup survey, referrals and recommendations are month-two work. They pay off more once readers are hearing from you every week.

---

## 9. What's next

Once you're publishing on schedule, the follow-up guide covers **earning money from your newsletter** with the same system: the beehiiv Ad Network, paid recommendations, digital products, paid subscriptions (with beehiiv's `upgrade-campaign` skill) and direct sponsorships (with its `media-kit` and `revenue-report` skills). All of them work better with a steady sending history and readers who open your emails, and these first 30 days give you both.

---

## 10. Appendix

### 10.1 ID prefixes you'll see

`pub_` publication · `post_` post · `post_template_` template · `aut_` automation · `poll_` poll · `nl_list_` newsletter list · `work_` workspace · `user_` user · `repo_skill:` beehiiv built-in skill. Recommendations, RSS feeds, segments, custom fields and tags often appear as raw UUIDs in block attributes. Follow each tool's description.

### 10.2 Automation triggers and steps (from `get_automation_schema`)

**Triggers (16):** `signup`, `manual`, `api`, `email_submission`, `form_submission`, `poll_submission`, `purchased_product`, `upgrade`, `downgrade`, `group_seat_filled`, `community_join`, `podcast_episode_published`, `link_click`, `unengaged`, `referral_action`, `segment_action`.

**Steps (10):** `send_email`, `wait_for`, `wait_until`, `branch`, `multi_split_branch`, `update_subscription`, `enroll_in_automation`, `send_community_message`, `webhook`, `exit`. Some (multi-path splits, random routing, A/B email variants, webhooks) depend on your plan.

Worth adding after day 30: **interest tagging** (`link_click` → `update_subscription` adds a tag, so the analyst can report which topics different readers click) and **re-engagement** (`unengaged` → an email you write asking whether they still want it → mark inactive).

### 10.3 What only you can do (in the beehiiv app)

Custom domain · custom sending domain · importing subscribers · turning on automations · publishing automation drafts · publishing subscribe forms left as drafts · sending posts on Free and Lite.

### 10.4 Sources

- [Getting started with the beehiiv MCP](https://www.beehiiv.com/support/article/39255979546263-getting-started-with-the-beehiiv-mcp)
- [What you can do with the beehiiv MCP](https://www.beehiiv.com/support/article/41262491804439-what-you-can-do-with-the-beehiiv-mcp)
- [What's included in a beehiiv free trial](https://www.beehiiv.com/support/article/22101553752471-whats-included-in-a-beehiiv-free-trial)
- [Using the beehiiv Agent](https://www.beehiiv.com/support/article/42007435101847-using-the-beehiiv-agent)
- [beehiiv plans and pricing (October 2026)](https://www.beehiiv.com/blog/beehiiv-pricing-2026)
- Live MCP references: `get_automation_schema`, `get_segment_schema`, `learn_post_authoring`, `learn_post_metadata`, and beehiiv built-in skills via `list_skills` (retrieved November 13, 2026); the post-theme token vocabulary and font list via `learn_post_authoring` (retrieved November 16, 2026)
- Claude Code docs: [Subagents](https://code.claude.com/docs/en/sub-agents), [Skills](https://code.claude.com/docs/en/skills), [MCP](https://code.claude.com/docs/en/mcp), [Headless mode](https://code.claude.com/docs/en/headless)
