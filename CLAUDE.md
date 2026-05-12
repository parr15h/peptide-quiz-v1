# PeptideMatch — build & tweak handoff

You are picking up a working V1 quiz funnel. Three static pages, no build step, deployed to Vercel. Edit, push, live in ~20 seconds. Your job is to keep iterating on copy, layout, data, and design fidelity. Don't break the rules engine or the navigation flow.

---

## URLs

- **Live:** https://peptidematch.vercel.app
- **Repo:** https://github.com/parr15h/peptide-quiz-v1
- **Figma source:** https://www.figma.com/design/5mmUQ9gU0VkV9E5971rCuR/Untitled?node-id=1-89 (landing reference at node `1:89`)
- **Local working dir:** `~/Documents/Claude/Projects/peptides/peptide-quiz-deploy/`

---

## The three pages

- **`index.html`** — Landing (Figma-locked dark navy hero) with Q1 baked into the hero tiles. Tap a tile → seamless slide-up quiz panel walks Q2–Q7 → navigates to results.
- **`results.html`** — Two-block results experience. Block 1: navy verdict block with YES/MAYBE/NO state variants, top peptide + 2 alternates, provider CTA. Block 2: cream alternatives with three groups (Tests / Products / People) + full-store CTA. Floating **Save This** button bottom-right opens a phone-capture sheet.
- **`store.html`** — Full per-bucket store: 30 picks split into Tests / Products / People, filterable by price tier (All / Under $50 / $50–500 / $500+), sticky "save my store" button at the bottom.

All single-file: inline CSS, inline JS, Google Fonts (Inter + Fraunces) from CDN. No frameworks. No npm deps. No build step. **Keep it that way** — the whole point is "edit file → push → live."

---

## How the data flows

1. User tapping Q1 → fires `q1_answered` event → slides quiz panel up.
2. Q2–Q7 collected into `state.answers` (in `index.html`).
3. `rulesEngine(state.answers)` outputs `{ verdict: YES|MAYBE|NO, bucket, confidence, reasonCode }`.
4. Result + answers + UTMs stored in `sessionStorage` AND encoded as URL params.
5. Navigate to `results.html?bucket=...&verdict=...&conf=...`.
6. `results.html` reads sessionStorage (falls back to URL params for share links).
7. `BUCKETS[bucket]` returns the routed store data: top peptides + tests / products / people arrays. Each V1 bucket maps to one of 10 segment stores (see `12_Bucket_Store_Catalog_300.xlsx` in `peptides-master/05_segments/` for the routing + commission data).

**Deep-link a test result (skip the quiz):**

```
https://peptidematch.vercel.app/results?bucket=energy_recovery&verdict=YES&conf=Strong+fit
https://peptidematch.vercel.app/results?bucket=perimenopause&verdict=YES&conf=Strong+fit
https://peptidematch.vercel.app/results?bucket=sleep&verdict=YES&conf=Strong+fit
https://peptidematch.vercel.app/results?bucket=skin_aging&verdict=YES&conf=Strong+fit
https://peptidematch.vercel.app/results?bucket=body_composition&verdict=MAYBE&conf=Worth+exploring
https://peptidematch.vercel.app/results?bucket=contraindicated&verdict=NO
```

---

## Iteration loop

```bash
# Open in browser
open index.html

# Or run a local server (closer to prod behavior)
python3 -m http.server 8000   # then http://localhost:8000

# Edit any of: index.html / results.html / store.html / vercel.json
# Then push:
git add -A && git commit -m "..." && git push
# Vercel auto-deploys main to https://peptidematch.vercel.app in ~20s
```

Diff against prod (not localhost) when comparing to Figma — font rendering and CDN behavior differ.

---

## Two-way Figma editing (already wired)

Two MCPs are connected: **h2d** (HTML → Figma, via the html.to.design plugin) and **Figma Dev Mode MCP** (Figma → code).

- **HTML → Figma:** the html.to.design plugin in Figma must be running with MCP endpoint enabled. Then call `import-url` with the live URL, or `import-html` with inline content. Imports land as a Figma frame you can edit visually.
- **Figma → HTML:** edit the imported frame in Figma, then call `get_design_context({ nodeId })` to read tokens + layout back. You manually splice the changes into the source HTML.

Heads-up: dynamic content (per-bucket data, JS-driven states), interactive states (the slide-up quiz panel, the save sheet), and paid fonts (Gotham) don't round-trip cleanly. Stay on Inter + Fraunces, edit static layout in Figma, edit JS data in code.

---

## Don't break

- **`rulesEngine(a)`** in `index.html` and `BUCKETS` + `renderBuyGroup` in `results.html` / `BUCKETS` in `store.html`. The decision logic and segment routing are locked.
- **State machine:** Q1 tile tap → quiz panel slide-up → Q2–Q7 → navigate to `results.html`. Don't reorder questions; "Step N of 7" labels are baked in.
- **Auto-advance behavior:** Q2 + Q4 + Q6 auto-advance after a tap. Q3 + Q5 + Q7 use the Continue button.
- **Event names** (`fire('q1_answered', ...)`, `fire('results_viewed', ...)`, etc.) — they're the funnel taxonomy. Don't rename.
- **URL parameter spine** — `utm_source`, `utm_medium`, `utm_campaign`, `v`, `lp`, `qz`, `cta` plus `bucket`, `verdict`, `conf`. Persist through every navigation. The dev chip top-left shows them when present.
- **The floating Save This button + sheet** in `results.html` — already locked behavior. Don't replace with a different save mechanic; iterate on copy/style if needed.

---

## What's still placeholder / V1 cut

- **Hero photograph** on `index.html` is a CSS gradient. The real Figma asset (`imgLayer21` from node 1:89) needs to be pulled and used as a `background-image` or `<img>`.
- **Hero logo** is text "PeptideMatch" rendered in Fraunces. The Figma has an actual lockup image (`imgPepMatchLogo1`).
- **SMS doesn't actually send.** The save sheet simulates the round-trip. Wire to Twilio / Resend SMS at the `// WIRE TO SMS PROVIDER HERE` comment in `results.html`.
- **Event firing** is `console.log` only. Uncomment the PostHog line in `fire()` once that account exists.
- **No clinical sign-off yet.** The peptide summaries are accurate-as-of-draft but launch path requires a clinical advisor signoff.

---

## First wins, if you're not sure where to start

1. Pull the actual hero photograph from Figma node `1:89` and replace the gradient placeholder in `index.html`.
2. Pull the actual PeptideMatch logo lockup from Figma and replace the styled text.
3. Tighten the typography on `index.html` per Figma: Gotham specs (headline 29px / -1.45px tracking, "in 2 minutes flat" 22px / `#9ADCFF`). Inter is the stand-in but can be tuned closer.
4. Replace the 5 Q1 tile icons with the actual SVGs from `mcp__Figma__get_design_context({ nodeId: "1:89" })` — the inline SVGs I drew are approximations.
5. Per-bucket curation pass — review the 30-item lists in `BUCKETS` in `results.html` and `store.html`. Currently `body_composition` and `joint_tendon` both route to S6 The Athlete. Splitting body composition into its own per-bucket curation is the next V1.5 step.
