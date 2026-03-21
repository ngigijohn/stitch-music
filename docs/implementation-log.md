# Implementation Log

Last updated: 2026-03-21

## What We Have Delivered
- Flutter app scaffolded from design assets with Material 3 dark expressive theme.
- Core playback stack integrated with just_audio.
- Android local music discovery migrated to native MediaStore via method channel.
- Local playback behaviors shipped: play/pause, seek, skip next/previous.
- Queue management shipped with drag-reorder and index-safe current track updates.
- Auto-advance on completion shipped.
- Session persistence shipped for queue IDs, current track, and position.
- Library diagnostics UI shipped (permission status, scan result count, scan errors).
- Playlist MVP shipped:
  - Create playlist from current queue.
  - Persist playlists in SharedPreferences.
  - Play playlist.
  - Delete playlist.
- QA baseline shipped:
  - Deterministic Track model parsing tests.
  - Theme contract test (with initialized test binding).
  - App shell smoke test.
- Branching and collaboration infrastructure shipped:
  - main, sprint/current, and per-agent branches.
  - CI workflow and PR/issue templates.
- YouTube streaming discovery and adapter scaffolding shipped (policy-compliant, fail-closed):
   - Discovery design doc with legal/compliance guardrails.
   - Stream source adapter interfaces and models.
   - YouTube adapter placeholder that does not extract or resolve unlicensed media.

## Major Milestones
1. Initial app build and UI architecture from provided design ZIP.
2. Build failure investigation around Android plugin compatibility.
3. Replacement of filesystem scan strategy with MediaStore channel approach.
4. User-verified milestone: device songs listed and playback working.
5. Parallel agent workflow setup and GitHub branch publication.
6. Playlist stream and QA stream completed, merged into sprint/current, then main.

## Learnings and Decisions

### 1) Android media access strategy
- Learning: Direct filesystem scanning is unreliable under modern Android scoped storage.
- Decision: Use MediaStore query on Android native side and return mapped song metadata over a method channel.
- Impact: Stable song discovery and better compatibility with current Android storage model.

### 2) Plugin/Gradle compatibility
- Learning: Some third-party plugins can fail under AGP 8+ if namespace/manifest requirements are not met.
- Decision: Remove incompatible plugin path and prefer native integration where needed.
- Impact: Debug build stability recovered.

### 3) State resilience
- Learning: Playback and queue state can drift during reorder/restore unless index adjustments are explicit.
- Decision: Centralize queue + index logic in PlaybackController and persist minimal identifiers.
- Impact: Fewer playback edge-case regressions after reorder and app relaunch.

### 4) Test reliability with Google Fonts
- Learning: Theme tests touching Google Fonts can fail if bindings are not initialized.
- Decision: Use widget-test binding initialization and disable runtime font fetching in tests.
- Impact: Deterministic tests in local and CI runs.

### 5) Parallel workflow hygiene
- Learning: Branch automation requires an initial commit (HEAD) before creating branch topology.
- Decision: Establish baseline commit first, then create sprint and agent branches.
- Impact: Smooth parallel lane execution and clean merge flow.

## Current Test Status (Latest Known)
- flutter test: passing.
- flutter analyze: passing.
- flutter build apk --debug: passing.

## What To Work On Next
1. Playback polish:
   - Repeat/shuffle modes.
   - Better end-of-queue behavior and error recovery UX.
2. Persistence hardening:
   - Versioned state keys/migration.
   - Favorites/recents persistence.
3. Diagnostics improvements:
   - More actionable permission troubleshooting UI.
   - Clear scan failure remediation actions.
4. Test expansion:
   - Integration coverage for full local playback path.
   - CI gates for release readiness.
5. YouTube streaming request:
   - Wire official API auth and entitlement checks into the compliant adapter.
   - Add read-only discovery UI with explicit playability states.
