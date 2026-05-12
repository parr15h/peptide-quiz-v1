# PUSH (good morning)

Cowork built the Figma-perfect homepage overnight but couldn't push from the sandbox —
GitHub auth lives in your Mac's Keychain, not in the agent. **One command finishes the job:**

```bash
cd ~/Documents/Claude/Projects/peptides/peptide-quiz-deploy
bash DEPLOY.sh
```

That script clears the stale `.git` locks the sandbox left, amends the existing local commit
into one clean change, and force-pushes to `main`. Vercel auto-deploys in ~20 seconds.

## What's in this commit

- **`index.html`** — replaced with a Figma-1:89-locked version. Real assets (woman photo,
  PeptideMatch logo lockup, 5 Q1 icons, CTA arrow) instead of CSS stand-ins. Typography
  pinned to Figma specs: 29 px / -1.45 px H1, 22 px / -1.1 px sky accent, 31 px /
  -1.55 px "Three steps." line, 19 px / -0.57 px founders quote with #C59478 accent,
  27 px / -1.08 px value-prop headlines in #613F25, 36 px Inter + Fraunces italic closing.
- **`assets/`** — 28 files exported from Figma node 1:89 (PNG + SVG).
- **`.gitignore`** — `.claude/` so worktree scratch doesn't get committed again.

## Quick verify after the push lands

1. Open https://peptidematch.vercel.app on a 402-px-wide viewport (or mobile).
2. Compare side-by-side to the Figma frame.
3. Re-run any pixel-perfect tool you'd like — the assets are now real, so the diff
   should collapse from "structural" to "tiny font-rendering differences."

## If `DEPLOY.sh` errors

The only thing that should fail is the GitHub push if the Keychain is empty. If it
prompts for a username/password:

```bash
git config --global credential.helper osxkeychain    # one-time setup
git push --force-with-lease origin main              # paste your GitHub PAT
```

After the first auth, it remembers. The script's other steps are idempotent —
re-running it is safe.

## What's still placeholder / V1 cut

Unchanged from the prior handoff:
- SMS doesn't actually send (the save sheet simulates).
- `fire()` is `console.log` only — wire to PostHog when the account exists.
- No clinical sign-off yet on the peptide summaries.

## Open question for you in the morning

The Figma headline uses Gotham; I rendered it in Inter 800 (the Google-Fonts-friendly
stand-in). Side-by-side with Figma on prod, decide whether (a) Inter 800 is close enough
to ship, or (b) we license Gotham via Adobe Fonts / Typekit and add the @import.
