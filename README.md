# PeptideMatch V1 — Deploy Package

Two static HTML files plus a `vercel.json`. Drag the folder to Vercel, get a public URL, send.

## What's in here

- `index.html` — Landing page (Figma-locked) with Q1 baked into the hero, plus the seamless slide-up quiz panel for Q2–Q7.
- `results.html` — Standalone results page with verdict block, peptide cards, provider CTA, and the alternatives block. Floating Save This button bottom-right opens a phone-capture sheet.
- `vercel.json` — Clean URLs, security headers, and a `/r/:slug` rewrite so shareable result links work.

## Deploy in 30 seconds (no Git required)

1. Open https://vercel.com/new
2. Click **"Browse"** under "Import Git Repository" → choose **"Continue without Git"** at the bottom of the dialog, OR drag this entire folder onto the dropzone.
3. Project name suggestion: `peptide-quiz-v1`.
4. Framework preset: **Other** (Vercel auto-detects it's static).
5. Click **Deploy**. You'll have a `*.vercel.app` URL in ~20 seconds.

## Deploy via CLI (if you have it installed)

```bash
cd peptide-quiz-deploy
npx vercel --prod
```

First run will prompt for login + project setup.

## Sending the link

The default URL Vercel gives you (e.g. `peptide-quiz-v1.vercel.app`) is fine for sharing.

If you want a UTM-tagged test link so events come through tagged for your tester:

```
https://[your-vercel-url].vercel.app/?utm_source=test&utm_medium=direct&utm_campaign=r0&v=v01&lp=lp-a&qz=qz-1&cta=cta-clarity
```

You'll see a small dev chip top-left on the page confirming the variant.

## What to ask your tester

1. Tap each of the 5 goal tiles in different sessions to confirm the 5 different routings work.
2. Try the perimenopause path: tap "Feel Like Myself Again" → in Q3 pick brain fog, hot flashes, period changes → Q4 age 45–54 → finish. You should land on The Hormonal Bridge Profile.
3. On results, tap the floating **Save This** button bottom-right. Enter a phone number, tap "Text my results" — you'll see the simulated SMS preview. (Real SMS provider isn't wired yet, see Known Limits below.)
4. Try the share-link fallback: copy this and open in a different browser — `https://[your-vercel-url].vercel.app/results?bucket=joint_tendon&verdict=YES&conf=Strong+fit` — should render someone else's result with a "this is a shared result" callout.

## Known limits in this build

- **Hero portrait is a placeholder.** Drop the actual photo into the file before public posting.
- **SMS doesn't actually send.** The submit handler simulates the round-trip and shows the preview message; wiring to Twilio / Resend SMS is a backend task (see comment block in `results.html` near `// WIRE TO SMS PROVIDER HERE`).
- **Event firing is `console.log` only.** Open browser DevTools → Console to see the funnel events. Uncomment one line at the end of each `fire()` function to wire PostHog when that account exists.
- **No clinical sign-off yet.** The peptide summaries are accurate-as-of-draft but the launch path requires a clinical advisor signoff per the V1 build plan.

## Files

```
peptide-quiz-deploy/
├── index.html       (43 KB — quiz + landing)
├── results.html     (45 KB — results page + Save sheet)
├── vercel.json      (1 KB — config)
└── README.md        (this file)
```

No build step. No dependencies beyond Google Fonts (loaded from CDN).
