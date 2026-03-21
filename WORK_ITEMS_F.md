# Agent F: Offline Caching - Work Items

**Branch**: `agent/f-offline-caching`  
**Priority**: HIGH  
**Focus**: Enable playback and discovery without internet  

## Completed ✅

None yet (just starting)

## In Progress 🔄

None yet

## Backlog 📋

### Tier 1: Core Offline Cache Service
- [ ] Create `lib/services/cache_service.dart`
  - [ ] `CacheEntry` model with track metadata, timestamp, size
  - [ ] `CacheManager` singleton with put/get/clear/size methods
  - [ ] Max cache size limit (e.g., 100MB, configurable)
  - [ ] LRU eviction when cache exceeds limit
  - [ ] Persist cache index to SharedPreferences with versioning
  - [ ] Tests: `test/services/cache_service_test.dart`

### Tier 2: Offline Mode Integration
- [ ] Update `lib/services/playback_controller.dart`
  - [ ] Add `isOfflineMode` getter and setter
  - [ ] When offline, check cache before trying network fetch
  - [ ] Show offline indicator in UI when active
  - [ ] Graceful fallback if track not in cache
  
- [ ] Update `lib/screens/library_screen.dart`
  - [ ] Add offline toggle switch in header or settings panel
  - [ ] Show "Offline Mode: ON" badge when active
  - [ ] Disable Online Search when offline
  - [ ] Show which tracks are cached (download icon indicator)

### Tier 3: Cache Management UI
- [ ] Create `lib/screens/cache_settings_screen.dart`
  - [ ] Show total cache size, number of cached tracks
  - [ ] "Clear All Cache" button with confirmation
  - [ ] Per-track cache removal (long-press action in Library)
  - [ ] Auto-cache on first play option
  - [ ] Cache size limit slider (10MB–500MB)

### Tier 4: Background Sync
- [ ] Add background sync when device returns online
  - [ ] Refresh metadata for cached tracks
  - [ ] Update availability status (track still exists upstream?)
  - [ ] Maintain cache freshness (optional expiry: 30 days)

## Testing Checklist

- [ ] Unit tests for `CacheManager` (put, get, evict, size)
- [ ] Widget test for offline toggle in Library
- [ ] Integration test: play from cache, verify no network calls
- [ ] Integration test: switch offline mode on/off, verify state
- [ ] Analyzer: `flutter analyze` clean
- [ ] Tests: `flutter test` all pass

## File Changes Summary

| File | Change | Reason |
|------|--------|--------|
| `lib/services/cache_service.dart` | NEW | Core caching logic |
| `lib/services/playback_controller.dart` | MODIFY | Offline mode support |
| `lib/screens/library_screen.dart` | MODIFY | Offline toggle UI |
| `lib/screens/cache_settings_screen.dart` | NEW | Cache management |
| `test/services/cache_service_test.dart` | NEW | Cache unit tests |
| `test/integration/offline_flow_test.dart` | NEW | Offline integration test |

## Merge Criteria

Before submitting PR to `sprint/current`:
- ✅ Analyzer clean
- ✅ All tests passing (unit + integration)
- ✅ Offline playback works end-to-end
- ✅ No network calls when offline
- ✅ Manual device test: download music, enable offline, play
- ✅ Commit message follows convention: `feat(offline): ...`
