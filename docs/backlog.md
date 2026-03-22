# Product Backlog

Last updated: 2026-03-22

## Current Focus

- Functional completion pass for dormant buttons, menus, and placeholder screens
- Accessibility and internationalization rollout across all user-facing surfaces
- Streaming backend hardening for policy-compliant remote playback
- Validation and release-readiness gates

## In Progress

- Online discovery currently runs in demo or fail-closed mode; official auth, entitlement refresh, and playback URI resolution remain pending
- Recently merged feature streams (offline cache, audio effects, export/share, insights, i18n) need an end-to-end UX completion pass and regression coverage

## Next Up

- Finish localization coverage across Home, Now Playing, Insights, playlists, dialogs, and banners
- Replace the discovery-only online search path with compliant, entitlement-gated playback integration
- Expand widget and integration coverage for merged navigation, playback, cache, and streaming flows
- Add CI release gates for `flutter analyze`, `flutter test`, and debug build validation

## Functional Gaps To Close

- Home screen: online playback messaging and recommendation follow-through need refinement
- Now Playing: device routing is still first-pass and can be deepened with platform route-pickers
- Profile screen: continue enriching profile/account behaviors and personalization
- Online Search / streaming: discovery works, but remote playback remains intentionally blocked until official provider integration is available
- Insights: empty states still need richer drill-down and recommendation follow-through

## Completed

- Device library scan via Android MediaStore method channel
- Local playback (play/pause/next/previous/seek)
- Auto-advance at track completion
- Queue reorder with playback index safety
- Repeat and shuffle modes
- Session restore for queue, current track, and position with versioned persistence keys
- Favorites and recents persistence
- Diagnostics panel with permission guidance, retry, and scan remediation actions
- Playlist enhancements: rename, add/remove individual tracks, reorder tracks, detail screen flow
- Integration tests for playlist CRUD and queue seeding helper flow
- Offline cache service, cache settings screen, and offline-mode library behavior
- Audio effects service, EQ panel in Now Playing, and settings-based EQ controls
- Export and share UI for playlists and tracks
- Analytics service, insights dashboard, and insights navigation tab
- Core i18n scaffolding plus initial localization of shell, library, and profile surfaces
- Phase 1 functional completion for Home, Now Playing, and Profile no-op controls
- Phase 2 profile hub upgrades with persisted local identity fields
- Phase 3 start: persisted language selector, high-contrast toggle, and expanded Settings information architecture
- Phase 3 continued: persisted text-scale control and global text scaling application
- Phase 3 continued: accessibility semantics labels for key controls plus settings preference persistence widget coverage
- Phase 3 completed: settings is now the app control center with persisted locale, high contrast, text scaling, cache linkage, and accessibility test coverage
- QA baseline tests (model mapping, theme contract, app shell smoke)
- Branch workflow and CI scaffolding for parallel agents

## Streaming Discovery

### Stream Audio From Licensed Provider APIs

Status: Foundation merged; official playback integration pending
Priority: High

Current scope:

1. Preserve policy-compliant architecture and avoid any unlicensed extraction path.
2. Add official provider auth and entitlement checks.
3. Resolve playback URIs only for entitled, provider-approved results.
4. Wire queue insertion and playback from online search only when compliant backend resolution succeeds.

Notes:

- Implementation must follow platform terms and copyright compliance.
- Demo mode and read-only discovery UI remain useful for UX validation.
- The adapter must continue to fail closed until official backend configuration is available.

## Future

- Artist and album detail pages
- Smart recommendations from local behavior
- Download and offline cache manager for permitted stream sources
