# Phase 1 Agent Breakdown

Last updated: 2026-03-22

## Objective

Parallelize Phase 1 functional completion so the highest-visibility no-op controls are replaced with real navigation, sheets, or working controls.

## Lane A: Home Surface

- Scope:
  - Wire `Daily Mixes -> See All`
  - Wire featured album CTA
  - Replace the top action/profile button with a quick-actions sheet
  - Ensure the Home screen routes into existing destinations cleanly
- Primary files:
  - `lib/screens/home_screen.dart`
  - `lib/screens/daily_mixes_screen.dart`
  - `lib/screens/album_spotlight_screen.dart`

## Lane B: Now Playing Actions

- Scope:
  - Implement the top-right more menu
  - Implement first-pass devices/output sheet
  - Wire volume and speed controls
  - Reuse playlist/share/settings flows instead of creating parallel logic
- Primary files:
  - `lib/screens/now_playing_screen.dart`
  - `lib/services/playback_controller.dart`

## Lane C: Profile Hub

- Scope:
  - Replace placeholder menu no-ops with working destinations
  - Add listening history screen
  - Add lightweight profile edit flow
  - Surface real stats from current app state where cheap and reliable
- Primary files:
  - `lib/screens/profile_screen.dart`
  - `lib/screens/listening_history_screen.dart`
  - `lib/screens/profile_edit_screen.dart`
  - `lib/services/analytics_service.dart`

## Shared Validation

- `flutter analyze`
- `flutter test`
- Add at least one targeted widget test for newly wired navigation

## Integration Notes

- Keep streaming playback fail-closed; do not bypass provider entitlement constraints.
- Prefer reusing existing screens (`Settings`, `CacheSettings`, `Insights`) rather than introducing duplicate destinations.
- Avoid large controller refactors during Phase 1; focus on visible functionality first.
