#!/usr/bin/env bash
# DEPLOY.sh — one-shot push the Cowork session's Figma-perfect homepage to Vercel.
#
# What this does:
#   1) Clears stale .git/HEAD.lock and .git/index.lock left behind by the sandbox.
#   2) Untracks .claude/ (the worktree the prior Cowork session accidentally committed).
#   3) Stages index.html + assets/ + .gitignore and amends the existing commit so
#      main lands as one clean commit instead of two.
#   4) Force-pushes (--force-with-lease) to GitHub → Vercel auto-deploys in ~20s.
#
# Run from this folder:    bash DEPLOY.sh

set -e
cd "$(dirname "$0")"

echo "→ 1/5  Clearing stale sandbox git locks…"
rm -f .git/HEAD.lock .git/index.lock

echo "→ 2/5  Resetting half-staged state from the sandbox…"
git reset HEAD >/dev/null 2>&1 || true

echo "→ 3/5  Untracking the accidentally-committed .claude worktree…"
if git ls-files --error-unmatch .claude >/dev/null 2>&1; then
  git rm -r --cached .claude >/dev/null
fi

echo "→ 4/5  Staging the new homepage + Figma assets + .gitignore…"
git add -A

echo "       Files that will be in the amended commit:"
git status -s | sed 's/^/         /'

echo "→ 5/5  Amending HEAD and pushing to main…"
git commit --amend --no-edit
git push --force-with-lease origin main

echo ""
echo "✓ Pushed. Watch the deploy land:"
echo "   • Build:  https://vercel.com/dashboard"
echo "   • Live:   https://peptidematch.vercel.app"
echo ""
echo "Compare to Figma:"
echo "   https://www.figma.com/design/5mmUQ9gU0VkV9E5971rCuR/Untitled?node-id=1-89"
