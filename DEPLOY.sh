#!/usr/bin/env bash
# DEPLOY.sh — push the Cowork session's pending changes to Vercel.
#
# What this does:
#   1) Clears stale .git/HEAD.lock and .git/index.lock left behind by the sandbox.
#   2) Untracks .claude/ if it ever sneaks back in.
#   3) Stages everything modified in this session.
#   4) Creates a fresh commit (vs amending — keeps history clean across multiple
#      Cowork rounds).
#   5) Pushes to GitHub → Vercel auto-deploys in ~20s.
#
# Run from this folder:    bash DEPLOY.sh
# Idempotent — safe to re-run.

set -e
cd "$(dirname "$0")"

echo "→ 1/5  Clearing stale sandbox git locks…"
rm -f .git/HEAD.lock .git/index.lock

echo "→ 2/5  Resetting half-staged state from the sandbox…"
git reset HEAD >/dev/null 2>&1 || true

echo "→ 3/5  Untracking .claude worktree (if present)…"
if git ls-files --error-unmatch .claude >/dev/null 2>&1; then
  git rm -r --cached .claude >/dev/null
fi

echo "→ 4/5  Staging changes…"
git add -A

# Bail with a friendly message if nothing actually changed
if git diff --cached --quiet; then
  echo ""
  echo "  (nothing staged — repo already matches origin/main)"
  exit 0
fi

echo "       Files in this commit:"
git status -s | sed 's/^/         /'

echo "→ 5/5  Committing and pushing…"
git commit -m "Cowork session: responsive homepage + unified results design"
git push origin main

echo ""
echo "✓ Pushed. Watch the deploy land:"
echo "   • Build:  https://vercel.com/dashboard"
echo "   • Live:   https://peptidematch.vercel.app"
echo ""
echo "Verify after Vercel finishes (~20s):"
echo "   • Homepage at three widths:"
echo "       https://peptidematch.vercel.app (mobile)"
echo "       Resize browser to 768px and 1280px to see desktop layout"
echo "   • Results page:"
echo "       https://peptidematch.vercel.app/results?bucket=energy_recovery&verdict=YES&conf=Strong+fit"
echo "       https://peptidematch.vercel.app/results?bucket=perimenopause&verdict=MAYBE&conf=Worth+exploring"
echo "       https://peptidematch.vercel.app/results?bucket=contraindicated&verdict=NO"
