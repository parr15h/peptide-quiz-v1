# PUSH (round 2 — good morning)

This is the second round of overnight changes. **Same one-command deploy:**

```bash
cd ~/Documents/Claude/Projects/peptides/peptide-quiz-deploy
bash DEPLOY.sh
```

### What's queued in this round

**`index.html` is now fully responsive.** The 402px Figma frame is still the source of truth — on mobile it renders exactly the same. At 480px+ the section backgrounds bleed to full viewport width via `::before` pseudos while the content stays in the centered 402px column. The hero swaps from `aspect-ratio: 402/1043` to fixed `height: 1043px` at desktop so the woman photo doesn't stretch into a 3322px monster on a 1280px screen. Smaller phones (<402px) keep the aspect-ratio scaling.

**`results.html` is rebuilt to feel like the same product as the homepage.** Same palette tokens (cream/warm-deep/warm-brown/warm-pill/sky/navy), same 36px Inter 800 + Fraunces italic headline treatment, same 287×72 brown pill CTA, same dark-wood closing block, same `#2A1D15` footer. The verdict block now uses the hero-woman photograph as a background with a dimmed navy overlay. Peptide cards are styled like Q1 tiles (sky-blue translucent pills) with the top-match card in cream with a warm-pill icon and "Top match" tag. The full-store CTA in Block 2 picks up the dark-wood gradient from the homepage closing. Save-FAB and the phone-capture sheet are reskinned in warm tones. All the JS — rules engine, bucket routing, sessionStorage handoff, SMS simulation, state-based visibility — is untouched.

**`DEPLOY.sh` updated.** Creates a fresh commit (instead of amending) so multi-round history is preserved. Still idempotent — safe to re-run.

### Verify after the deploy lands

**Homepage at three widths** (any browser, just resize):
- ~375px → mobile, hero auto-scales
- 480px → mobile design exactly, no side bleed visible
- 1280px → 402px column centered, section backgrounds extend to viewport edges, hero photo bleeds full-width

**Results page at three states:**
- https://peptidematch.vercel.app/results?bucket=energy_recovery&verdict=YES&conf=Strong+fit
- https://peptidematch.vercel.app/results?bucket=perimenopause&verdict=MAYBE&conf=Worth+exploring
- https://peptidematch.vercel.app/results?bucket=contraindicated&verdict=NO

After it lands, ping me with "re-run pixel-perfect" or "audit the results page" and I'll diff the new build against Figma + verify the homepage→results visual continuity.

---

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
