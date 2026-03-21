# Product Backlog

## In Progress
- Playback polish: repeat and shuffle modes
- Persistence hardening: queue/order/versioned session state
- Diagnostics UX refinements and actionable permission guidance
- YouTube streaming discovery (policy-compliant architecture and API path)

## Next Up
- Favorites and recents persistence
- Playlist enhancements: rename, add/remove individual tracks, reorder tracks
- Integration tests for scan -> play -> queue -> playlist flow
- CI release gates (analyze, tests, debug build)

## Completed
- Device library scan via Android MediaStore method channel
- Local playback (play/pause/next/previous/seek)
- Auto-advance at track completion
- Queue reorder with playback index safety
- Session restore for queue/current track/position
- Library diagnostics panel (permission, last scan, counts)
- Playlist MVP (create from queue, play, delete, persistence)
- QA baseline tests (model mapping, theme contract, app shell smoke)
- Branch workflow and CI scaffolding for parallel agents

## New Feature Request
### Stream Audio from YouTube
Status: Discovery (active)
Priority: High

Scope for discovery:
1. Evaluate legal and policy-compliant integration paths.
2. Confirm allowed use cases (user-authenticated streaming, licensed APIs).
3. Define architecture for remote stream source adapters.
4. Add UI entry points and playback queue integration.

Notes:
- Implementation must follow platform terms and copyright compliance.
- Avoid unlicensed extraction workflows.
- Adapter currently fails closed until official API auth + entitlement are wired.

## Future
- Artist and album detail pages
- Smart recommendations from local behavior
- Download and offline cache manager for permitted stream sources
