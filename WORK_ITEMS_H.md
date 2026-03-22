# Agent H: Export & Sharing - Work Items

**Branch**: `agent/h-export-sharing`  
**Priority**: MEDIUM  
**Focus**: Export playlists, share tracks, social features  

## Completed ✅

None yet (just starting)

## Backlog 📋

### Tier 1: Export Service
- [ ] Create `lib/services/export_service.dart`
  - [ ] Export playlist as M3U (standard format for media players)
  - [ ] Export as CSV (spreadsheet-friendly)
  - [ ] Export as JSON (custom format with metadata)
  - [ ] Include cover art paths in exports where available
  - [ ] Tests: `test/services/export_service_test.dart`

### Tier 2: Share UI (Playlists)
- [ ] Update `lib/screens/playlist_detail_screen.dart`
  - [ ] Add "Share Playlist" button in header
  - [ ] Open share dialog with export options:
    - [ ] Generate shareable link (via Firebase Dynamic Links or similar)
    - [ ] Share as file (M3U, CSV, JSON)
    - [ ] Copy to clipboard (JSON summary)
    - [ ] Share via email, messaging, social
  - [ ] Show share count and recent sharers (optional)

### Tier 3: Share UI (Tracks)
- [ ] Update `lib/screens/now_playing_screen.dart`
  - [ ] Add "Share Track" button in controls
  - [ ] Share dialog with:
    - [ ] Direct share (system share sheet)
    - [ ] Copy track info to clipboard (artist • title)
    - [ ] Copy Spotify/YouTube link (if available)

### Tier 4: Deep Link Handling
- [ ] Create `lib/services/deep_link_handler.dart`
  - [ ] Handle shared playlist links (`stitch://playlist/{id}`)
  - [ ] Import shared playlist on tap
  - [ ] Handle Android/iOS shared files
  - [ ] Show import confirmation dialog
  - [ ] Tests: `test/services/deep_link_handler_test.dart`

### Tier 5: Import Flow
- [ ] Add import UI in Library
  - [ ] "Import Playlist" button or link
  - [ ] File picker to select M3U/CSV/JSON
  - [ ] Validate and import, show results
  - [ ] Handle missing tracks gracefully

## Testing Checklist

- [ ] Unit tests for export formats (M3U, CSV, JSON)
- [ ] Widget test for share dialogues
- [ ] Integration test: export playlist, verify file integrity
- [ ] Integration test: import exported playlist, verify contents match
- [ ] Deep link test: open shared link, import playlist
- [ ] Analyzer: `flutter analyze` clean
- [ ] Tests: `flutter test` all pass

## File Changes Summary

| File | Change | Reason |
|------|--------|--------|
| `lib/services/export_service.dart` | NEW | Export logic |
| `lib/services/deep_link_handler.dart` | NEW | Deep link routing |
| `lib/screens/playlist_detail_screen.dart` | MODIFY | Share button + dialog |
| `lib/screens/now_playing_screen.dart` | MODIFY | Track share button |
| `lib/screens/library_screen.dart` | MODIFY | Import button |
| `test/services/export_service_test.dart` | NEW | Export tests |

## Merge Criteria

Before submitting PR to `sprint/current`:
- ✅ Analyzer clean
- ✅ All tests passing
- ✅ Export file formats valid and importable
- ✅ Share dialogs appear correctly
- ✅ Manual device test: export, share, import
- ✅ Commit message: `feat(sharing): add export and playlist sharing`
