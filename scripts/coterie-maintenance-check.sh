#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! git remote get-url upstream >/dev/null 2>&1; then
  echo "Missing upstream remote. Add it with:"
  echo "  git remote add upstream https://github.com/paperclipai/paperclip.git"
  exit 1
fi

echo "Paperclip Coterie fork maintenance check"
echo "Repository: $repo_root"
echo

git fetch origin
git fetch upstream

current_branch="$(git branch --show-current)"
echo "Current branch: ${current_branch:-detached}"
echo

echo "Working tree:"
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
  echo "  clean"
else
  git status --short | sed 's/^/  /'
fi
echo

echo "master vs upstream/master:"
git rev-list --left-right --count upstream/master...master | awk '{ print "  upstream-only: " $1 "\n  fork-only:     " $2 }'
echo

echo "Recent upstream commits:"
git log --oneline --decorate -5 upstream/master
echo

echo "Local coterie branches:"
coterie_branches="$(git for-each-ref --format='%(refname:short)' refs/heads/coterie)"
if [ -z "$coterie_branches" ]; then
  echo "  none"
  exit 0
fi

printf '%s\n' "$coterie_branches" | while IFS= read -r branch; do
  if [ -z "$branch" ]; then
    continue
  fi

  echo
  echo "Branch: $branch"
  git rev-list --left-right --count upstream/master..."$branch" | awk '{ print "  upstream-only: " $1 "\n  branch-only:   " $2 }'
  echo "  branch commits:"
  git log --oneline upstream/master.."$branch" | sed 's/^/    /'

  merge_base="$(git merge-base upstream/master "$branch")"
  if git merge-tree "$merge_base" upstream/master "$branch" | grep -q '^<<<<<<< '; then
    echo "  conflict-check: likely conflicts"
  else
    echo "  conflict-check: no textual conflicts detected"
  fi
done
