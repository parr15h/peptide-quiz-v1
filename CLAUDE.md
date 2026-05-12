# Make the live site match the Figma

**Live:** https://peptidematch.vercel.app
**Figma:** https://www.figma.com/design/5mmUQ9gU0VkV9E5971rCuR/Untitled?node-id=1-89 (node `1:89`)
**Repo:** https://github.com/parr15h/peptide-quiz-v1

## To read the Figma

Open Figma desktop → Preferences → **Enable Dev Mode MCP Server** → restart Claude Code. Then:

```
mcp__Figma__get_design_context({ nodeId: "1:89" })
mcp__Figma__get_screenshot({ nodeId: "1:89" })
```

## The files

- `index.html` — landing page (hero + Q1 tiles) + slide-up quiz panel for Q2–Q7
- `results.html` — results page (verdict + peptide cards + provider CTA + alternatives + floating Save This sheet)
- `vercel.json` — config, don't edit

Single-file, inline CSS, inline JS, Google Fonts from CDN. No build step. No npm deps. Keep it that way.

## Deploy

```
git add -A && git commit -m "..." && git push
```

Vercel auto-deploys `main` to https://peptidematch.vercel.app in ~20 seconds.

## Known visual gaps

1. Hero photo is a placeholder gradient — pull the real asset from Figma (`imgLayer21`)
2. Logo is styled text — Figma has a real lockup (`imgPepMatchLogo1`)
3. Body font is Inter — Figma uses Gotham (paid; license, use Adobe Fonts, or stay on Inter and match weights/kerning)
4. Q1 tile icons are approximations — replace with the actual SVGs from `get_design_context`
5. Typography sizes / weights / letter-spacing throughout — extract from the Figma per node

Don't trust this list to be complete. Diff every section.

## Don't break

- Rules engine — `function rulesEngine(a)` in `index.html`, `PROFILE_MAP` + `ALT_MAP` in `results.html`
- State machine — Q1 tile tap → quiz panel slide-up → Q2–Q7 → navigate to `results.html`
- Event names — `fire('q1_answered', ...)` etc. Don't rename.
- The 7-question count and the auto-advance behavior (Q2 + Q4 + Q6 auto-advance; Q3 + Q5 + Q7 use Continue)

## Done when

Screenshot live site at 402px viewport. Screenshot Figma node `1:89`. Indistinguishable. Quiz still completes a full happy path with zero console errors. Save This button still opens the phone sheet on results.
