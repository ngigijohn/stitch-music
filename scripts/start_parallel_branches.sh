#!/usr/bin/env bash
set -euo pipefail

# Creates sprint and agent branches for parallel execution.

BASE_BRANCH="main"
SPRINT_BRANCH="sprint/current"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository"
  exit 1
fi

git checkout "$BASE_BRANCH"
git pull --ff-only || true

git checkout -B "$SPRINT_BRANCH"

declare -a branches=(
  "agent/a-playback"
  "agent/b-persistence"
  "agent/c-library-diagnostics"
  "agent/d-playlists"
  "agent/e-qa"
)

for b in "${branches[@]}"; do
  git branch -f "$b" "$SPRINT_BRANCH"
  echo "Prepared branch: $b"
done

echo "Done. Use: git checkout agent/a-playback"
