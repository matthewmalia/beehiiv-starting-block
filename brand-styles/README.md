# Brand styles

Three ready-made looks for your newsletter, so you never start from a blank page. `/start` asks you to pick one and applies it to your post template in beehiiv. Every post built from that template then looks the same.

**See them first:** open [`preview.html`](preview.html) in your browser.

| Style | Feels like | Headings | Body | Page | Accent |
|---|---|---|---|---|---|
| **Clean** | Modern and quiet | Inter | Inter | White | Blue `#2563EB` |
| **Editorial** | A magazine column | Playfair Display | Lora | Warm paper `#F4EFE6` | Deep red `#9B2C2C` |
| **Bold** | High contrast, energetic | Space Grotesk | DM Sans | Dark navy `#0F172A`, white card | Orange `#F97316` |

Not sure? Pick **Clean**. You can change it at any time: tell the Publishing Lead "switch my brand style to Editorial".

## Your own style

`/start` gives you one of the three presets. Whenever you want your own colours or fonts, tell the Publishing Lead, and you still don't start from nothing. The Lead asks three short questions:

1. Which of the three is closest to what you want? (That becomes the base.)
2. What is your brand colour? A hex code like `#0A7C66`, or a colour name the Lead turns into one for you to confirm.
3. Keep the base fonts, or swap them? If you swap, you choose from beehiiv's font list, with a few suggestions.

The Lead saves the result as `brand-styles/custom.json` so it can be re-applied.

**Have a style guide?** Drop it (and your logo) in `inbox/` any time after `/start`, or paste it into the chat. The Lead reads the colours and fonts from it instead of asking these questions, picks the nearest preset as the base, and shows the result for a yes. The guide and logo are kept in this folder as `style-guide.<ext>` and `logo.<ext>`.

## How a style is applied (for the agents)

Each `<style>.json` holds:

- `theme_data`: a map of beehiiv post-theme tokens. Pass it as-is to `save_post_template_theme(publication_id, post_template_id, theme_data)`. Only the keys sent are changed.
- `accent_tokens`: the tokens that carry the accent colour. For a custom style, replace the value of each with the writer's colour.
- `accent_text_tokens` (Bold only): accent tokens that sit on a white background as text. They use a darker shade so links stay readable. For a custom colour, darken it until it has at least 4.5:1 contrast against the content background, and tell the writer if you did.
- `fonts`, `colors`, `summary`: what to tell the writer.

Rules:

- Apply the style to the **post template**, not to single posts. `save_post_theme` changes one post only.
- Font names must come from beehiiv's font list (`learn_post_authoring` with `node: "textStyle"`). A font that isn't on the list is dropped without an error.
- Check contrast before saving a custom style: body text and links against the content background, and button text against the button colour. Don't save a combination below 4.5:1; propose the nearest shade that passes.
- After applying, call `learn_post_authoring` with `node: "theme"` only if you need the full token list. Record the chosen style in `config/publication.yaml` under `brand.style`.
- **Free plan (paste-in mode):** the MCP can't write. Give the writer the fonts and colours from the table above to set by hand in beehiiv's post design settings.

The token names were checked against beehiiv's live theme vocabulary on November 16, 2026. beehiiv may add or rename tokens; if a save reports an unknown key, drop that key, tell the writer, and carry on.
