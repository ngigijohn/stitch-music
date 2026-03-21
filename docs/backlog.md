# Product Backlog

## In Progress
- Playback polish: repeat and shuffle modes
- Persistence hardening: queue/order/versioned session state
- Diagnostics UX refinements and actionable permission guidance

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
Status: **Implemented (Sprint)**
Priority: High

Architecture implemented:
1. **YouTubeService** (`lib/services/youtube_service.dart`) — YouTube Data API v3 search.
2. **YouTubeSearchScreen** (`lib/screens/youtube_search_screen.dart`) — Discover tab with search, API key config, and result list.
3. **YouTubePlayerScreen** (`lib/screens/youtube_player_screen.dart`) — In-app player using the official YouTube IFrame API via `youtube_player_flutter`.
4. **Playlists** accessible from Library header button and Library long-press on nav.

Compliance:
- Uses the official YouTube IFrame Player (ToS-compliant, no raw stream extraction).
- Requires user-supplied YouTube Data API v3 key (free quota from Google Cloud Console).
- API key stored locally via `SharedPreferences` — never transmitted to third parties.
- Playback disclaimer shown to user in player screen.

## Future
- Artist and album detail pages
- Smart recommendations from local behavior
- Download and offline cache manager for permitted stream sources
