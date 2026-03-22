# Functional Completion Plan

Last updated: 2026-03-22

## Goal

Close the gap between visual UI polish and real behavior by wiring no-op controls, replacing placeholder screens, and sequencing the remaining implementation work on top of the features already merged into `sprint/current`.

## Gap Inventory

### Home

- `lib/screens/home_screen.dart`
- `Daily Mixes -> See All` is a no-op.
- Featured album CTA (`Explore Album`) is a no-op.
- Top action button is a no-op.
- Home still contains copy indicating online playback is not enabled yet, even though the streaming/discovery architecture has advanced.

### Now Playing

- `lib/screens/now_playing_screen.dart`
- Top-right more menu is a no-op.
- `Devices` bottom action is a no-op.
- `Volume` and `Speed` pills are present but not wired to controls.
- EQ and Share are implemented, so the screen already has a pattern for action sheets that should be reused.

### Profile

- `lib/screens/profile_screen.dart`
- The screen is still labeled as a minimal placeholder.
- All menu items render but use no-op handlers.
- The screen should become the user/account/settings hub rather than a static mock.

### Online Discovery And Remote Playback

- `lib/screens/online_search_screen.dart`
- `lib/services/streaming/stream_backend_gateway.dart`
- `lib/services/streaming/youtube_compliant_discovery_adapter.dart`
- `lib/services/playback_controller.dart`
- Discovery works in demo/fail-closed mode, but playback is intentionally blocked because entitlement-backed URI resolution is not implemented.

### Settings And Accessibility

- `lib/screens/settings_screen.dart`
- Settings currently focuses on EQ only.
- Language selection, accessibility controls, and global app behavior toggles are not yet surfaced.

## Delivery Plan

### Phase 1: Wire Existing UI To Real Destinations

Status: Completed and merged into `sprint/current`

Objective: remove the highest-visibility no-op controls without changing architecture unnecessarily.

Work:

1. Home:
   - Route `See All` to a full mixes or recommendation list screen.
   - Route `Explore Album` to a release-detail or album-detail surface.
   - Convert the top action icon into a real quick-actions sheet (Settings, Cache, Insights, Profile).
2. Now Playing:
   - Implement a `TrackActionsSheet` for the more menu using existing share/export, favorite, playlist, and settings actions.
   - Add a first-pass output-device action for `Devices`.
3. Profile:
   - Replace no-op menu handlers with real navigation to Settings, Downloads/Cache, History/Recents, and profile edit flow.

Primary files:

- `lib/screens/home_screen.dart`
- `lib/screens/now_playing_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/screens/cache_settings_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/screens/insights_screen.dart`

Acceptance criteria:

- No visible primary CTA on Home, Now Playing, or Profile is left as a no-op.
- Each action either performs a real function or opens a real destination/sheet.
- Widget tests cover the new navigation and action wiring.

### Phase 2: Turn Profile Into A Real Hub

Status: Completed and merged into `sprint/current`

Objective: make Profile the place where user-oriented features converge instead of leaving settings and history fragmented.

Work:

1. Replace mock profile stats with values backed by `AnalyticsService` and playback/history state.
2. Connect profile items to:
   - Edit profile / account placeholder flow
   - Listening history / recents
   - Downloads / cache management
   - Settings
3. Add room for locale, theme, and accessibility shortcuts.
4. Persist local profile identity fields so the Profile hub reflects user changes.

Primary files:

- `lib/screens/profile_screen.dart`
- `lib/services/analytics_service.dart`
- `lib/services/playback_controller.dart`

Acceptance criteria:

- Profile actions navigate to working destinations.
- Stats are data-backed instead of hardcoded mock values.

### Phase 3: Finish Settings As The App Control Center

Status: In progress

Objective: expand Settings beyond EQ so it can host the next wave of product controls.

Work:

1. Add language selector with persisted locale.
2. Add accessibility section placeholders with working toggles where implementation exists.
3. Link to cache/offline settings and high-contrast mode once available.
4. Keep EQ controls in place as one section of a broader settings experience.

Started in this phase:

- Added `AppPreferencesService` for persisted locale and high-contrast preferences.
- Wired app-level locale + high-contrast handling in `main.dart`.
- Expanded `SettingsScreen` with Language, Accessibility, General, and Audio sections.
- Added persisted text-scale controls in Settings and applied text scaling app-wide through `MaterialApp.builder`.
- Added semantics labels/hints to critical controls in Settings, Home quick actions, and Now Playing controls.
- Added widget coverage for settings preference persistence (locale, high contrast, text scale).

Next in this phase:

- Add semantics-first audits for key controls on Home, Now Playing, and Settings.
- Add explicit widget assertions for semantics discoverability in Home and Now Playing.
- Run RTL and large-text layout passes on primary screens and fix overflow/focus issues.
- Add widget coverage for locale/high-contrast/text-scale persistence flows.

Primary files:

- `lib/screens/settings_screen.dart`
- `lib/main.dart`
- `lib/l10n/app_*.arb`

Acceptance criteria:

- Locale can be changed in-app and persists across relaunch.
- Settings owns global configuration rather than scattered one-off entry points.

### Phase 4: Complete Policy-Compliant Online Playback

Objective: move from discovery-only remote results to an entitled playback path without violating provider policy.

Work:

1. Implement official provider auth and entitlement refresh flow.
2. Extend `StreamBackendGateway.resolvePlaybackUri()` to return provider-approved URIs only for valid entitlements.
3. Add remote-source playback entry points in `PlaybackController`.
4. Wire `OnlineSearchScreen` result actions to queue insertion and playback only when URI resolution succeeds.
5. Preserve clear fail-closed UX when credentials, auth, or entitlements are unavailable.

Primary files:

- `lib/services/streaming/stream_backend_gateway.dart`
- `lib/services/streaming/youtube_compliant_discovery_adapter.dart`
- `lib/services/streaming/stream_adapter_registry.dart`
- `lib/screens/online_search_screen.dart`
- `lib/services/playback_controller.dart`

Acceptance criteria:

- Demo mode still works for UX validation.
- Production mode remains policy-compliant and fail-closed.
- Entitled users can insert playable online results into the queue.

### Phase 5: Finish Accessibility And Internationalization Rollout

Objective: complete the work that J started so the app is globally usable and internally consistent.

Work:

1. Localize all remaining screens, dialogs, snackbars, tooltips, and banners.
2. Add locale persistence and language selector UX.
3. Implement RTL validation and layout fixes.
4. Add semantics, focus behavior, text scaling checks, and high-contrast support.

Primary files:

- `lib/screens/home_screen.dart`
- `lib/screens/now_playing_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/screens/insights_screen.dart`
- `lib/screens/playlists_screen.dart`
- `lib/l10n/app_*.arb`
- `lib/theme/app_theme.dart`

Acceptance criteria:

- No user-facing hardcoded English remains in primary flows.
- RTL and larger text sizes do not break key screens.
- Critical controls expose semantics for screen readers.

### Phase 6: Validation And Release Gates

Objective: protect the larger merged feature set from regressions.

Work:

1. Add widget tests for Home, Profile, and Now Playing actions.
2. Add integration tests for:
   - scan -> play -> queue -> playlist
   - cache/offline toggle flows
   - locale switching
   - online discovery to entitled playback (when backend is available)
3. Add CI release gates for `flutter analyze`, `flutter test`, and debug build.

Primary files:

- `test/`
- `.github/workflows/`

Acceptance criteria:

- Newly wired buttons are covered by tests.
- Merge confidence does not depend on manual smoke testing alone.

## Suggested Execution Order

1. Phase 1: wire no-op UI controls on Home, Now Playing, and Profile.
2. Phase 2 and 3 together: real Profile hub plus Settings expansion and persisted locale.
3. Phase 5: finish localization and accessibility rollout across remaining screens.
4. Phase 4: complete compliant online playback once provider auth/backend requirements are available.
5. Phase 6 continuously as each phase lands.

## Risks And Decisions Needed

1. Output-device support needs a product/technical decision: native route picker plugin vs. app-owned device sheet.
2. Online playback remains blocked on provider-approved auth and entitlement infrastructure.
3. Profile/account behavior needs a product decision on whether the app is local-only or provider/account-aware.
