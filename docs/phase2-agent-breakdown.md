# Phase 2 Agent Breakdown

Last updated: 2026-03-22

## Objective

Turn Profile into a genuine user hub by persisting identity details, surfacing listening data, and exposing high-value shortcuts into the surrounding feature set.

## Lane A: Profile Data

- Add lightweight persisted profile preferences for display name and email.
- Replace placeholder identity text with saved values.
- Keep the storage local and simple.

Primary files:

- `lib/services/profile_preferences_service.dart`
- `lib/screens/profile_edit_screen.dart`
- `lib/screens/profile_screen.dart`

## Lane B: Profile Hub Surface

- Add data-backed listening snapshot cards.
- Add quick access cards for Insights, History, Offline, and Settings.
- Keep the existing Profile menu for deeper actions.

Primary files:

- `lib/screens/profile_screen.dart`
- `lib/services/analytics_service.dart`
- `lib/services/playback_controller.dart`

## Lane C: Validation

- Keep `flutter analyze` and `flutter test` green.
- Extend test coverage later if the Profile flow gains more persistent branches.

## Integration Notes

- Phase 2 should not expand global settings behavior yet; that belongs to Phase 3.
- Keep account behavior local-only until a product decision introduces provider or cloud identity.
