# Parallel Agent Workflow

## Goal

Enable up to 5 concurrent agents without merge conflicts.

## Branch Layout

- main: integration branch (currently includes sprint/current merge)
- sprint/current: active staging branch for ongoing sprint work
- agent/a-playback
- agent/b-persistence
- agent/c-diagnostics
- agent/d-playlists
- agent/e-qa

## Assignment Matrix

- Agent A: Playback polish and runtime stability
- Agent B: Persistence and resume state
- Agent C: Library diagnostics and permission UX
- Agent D: Playlist MVP
- Agent E: Tests, CI checks, and release gates

## Rules

1. One workstream per branch.
2. Rebase daily on sprint/current.
3. PR target is sprint/current, not main.
4. Keep PRs small, under 400 lines when possible.
5. Must pass flutter analyze and flutter test before review.

## Daily Sync

1. 10 minute standup
2. Update blockers and ownership
3. Merge order based on dependency chain:
   1. core services
   2. persistence
   3. UI integration
   4. tests

## Fast Conflict Protocol

1. Owner of conflicting file resolves merge.
2. If unresolved within 15 minutes, escalate to lead branch owner.
3. Prefer additive changes and extension methods over deep rewrites.

## Definition of Done

1. CI green on PR.
2. Manual Android smoke test complete.
3. Acceptance criteria in issue checked.
4. No analyzer warnings.
