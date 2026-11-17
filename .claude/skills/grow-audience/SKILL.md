---
name: grow-audience
description: Set up the audience pieces that were left out of getting started - the welcome email, the subscribe form and exit pop-up, a one-question signup survey, a referral program, and recommendations. The writer picks which to do; each is independent. Run once the weekly publishing habit is steady, typically after three or four posts.
argument-hint: [welcome|form|survey|referral|recommendations]
disable-model-invocation: true
---

# /grow-audience

None of this is needed to publish, which is why it isn't in `/start`. It becomes worth doing once posts are going out every week. Each piece is independent and takes five to fifteen minutes.

If `$ARGUMENTS` names a piece, go straight to it. Otherwise:

1. Check what exists: `list_automations`, `list_subscribe_forms`, `list_surveys`, `get_referral_program`, `list_recommendations`.
2. Show the five pieces as a short menu with what's done and what isn't, in the recommended order below.
3. Ask which one they want to do now. Do that one. Offer the next when it's finished, and stop if they've had enough.

In paste-in mode (`access.mode` in the config; see "Modes" in `CLAUDE.md`) the MCP can't write: for each piece, write what's needed to a file and give the writer the steps to do by hand in the app. Automations need a paid plan after the trial. On a likely trial (`access.trial`), say before building an automation that it switches off when the trial ends unless they upgrade.

Two rules for every piece: the writer writes any text a reader will see, and nothing goes live without them. Forms and automations are built as drafts.

## 1. Welcome email (recommended first)

1. Give the writer `templates/welcome-email-prompts.md`. **They write it**, into `inbox/welcome.md` or the chat. Wait for it.
2. Delegate to the `editor` (Stage 1, then final and checks) in `posts/_welcome/`.
3. `get_automation_schema`, then `save_automation` with `templates/welcome-automation.json`, the publication id, and the writer's subject line and preview text.
4. Find the `send_email` step id (`list_automation_emails` or `get_automation`). The `editor` places the text with `save_automation_email`.
5. Tell the writer: **the automation is a draft. Open it in the beehiiv app, read it, publish it and turn it on.** Never describe it as live. Save the automation id to the config.

## 2. Subscribe form and exit pop-up

1. `learn_subscribe_form_authoring` first.
2. Ask for the headline and one line of supporting text. The promise in the config is usually the headline; confirm it in their words.
3. `save_subscribe_form` for the main form, then for a pop-up shown when a visitor is about to leave (`render_type: popup`, `trigger_type: exit_intent`). Offer the pop-up; don't assume it.
4. Forms follow a draft/publish workflow. Follow what `learn_subscribe_form_authoring` says and tell the writer if publishing is theirs to do. Save the form ids to the config.
5. Remind them where else the subscribe link belongs: bio, email signature, other channels.

## 3. Signup survey

One question, saved to a custom field, so the analyst can report the answers and the Lead can turn them into ideas.

1. Ask for the question and three to five answer options. Suggest the question "What do you most want help with?"; the options are theirs.
2. `save_custom_field` (`kind: list`) → `save_survey` (`type: subscribe`) → `save_survey_question` mapped to the field. Save the ids to the config.

## 4. Referral program

1. Ask for one reward that costs nothing (a bonus post or a resource) and how many referrals earn it.
2. `save_referral_program`, then `save_referral_reward` and `save_referral_milestone`.
3. Ask the writer for one sentence on why to share. Then delegate to the `editor` to add a referral card (their sentence plus the `referralProgram` block, see `templates/post-skeleton.html`) to the post template after the body, once `learn_post_authoring` shows the block as `available`. Show the writer before saving.

## 5. Recommendations

1. `list_recommendation_suggestions` and `discover_publications` for three to five similar newsletters. Show them with a line on each.
2. For each one the writer picks, **they write the one-line reason** readers will see. Then `save_recommendation`.
3. Mention that newsletters you recommend often recommend you back.
4. Remind the writer in one line that beehiiv matches recommendations by their three categories (`publication_tags` in the config), and ask whether they still fit. If not, change them as in "Categories" in `CLAUDE.md`.

## When a piece is done

Update `config/publication.yaml` with the ids and list anything that is the writer's to finish in the beehiiv app.
