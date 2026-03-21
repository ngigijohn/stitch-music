# 10-Agent Parallel Workflow Scope

## Agent Overview

### ✅ COMPLETED (Merged to main)
- **agent/a-playback**: Core playback, repeat/shuffle, queue management
- **agent/b-persistence**: SharedPreferences, session state, versioning
- **agent/c-diagnostics**: Permission UX, scan status, retry actions
- **agent/d-playlists**: Playlist CRUD, reorder, rename
- **agent/e-qa**: Unit/widget/integration tests, deterministic coverage

---

## 🚀 ACTIVE (Ready for Parallel Work)

### agent/f-offline-caching
**Focus**: Enable playback without internet, cache management
- [ ] Implement local cache layer for discovered tracks (metadata + duration)
- [ ] Add offline mode toggle in Library screen
- [ ] Persist discovered online tracks locally for playback when offline
- [ ] Show cache size, clear cache UI
- [ ] Sync cache in background when online
**Files to touch**: 
  - `lib/services/cache_service.dart` (NEW)
  - `lib/screens/library_screen.dart` (add offline mode toggle)
  - `lib/services/playback_controller.dart` (use cache for offline)
**Priority**: HIGH — Critical for UX when traveling or in poor connectivity

---

### agent/g-audio-effects
**Focus**: Audio processing, equalizer, sound profiles
- [ ] Add equalizer UI with 5-band controls (bass, treble, mids, etc.)
- [ ] Store EQ presets (Normal, Bass Boost, Treble Boost, custom)
- [ ] Integrate with just_audio's audio processing pipeline
- [ ] Show EQ icon on Now Playing screen
- [ ] Persist EQ settings in SharedPreferences
**Files to touch**:
  - `lib/services/audio_effects_service.dart` (NEW)
  - `lib/screens/now_playing_screen.dart` (add EQ toggles)
  - `lib/screens/settings_screen.dart` (NEW - EQ presets)
**Priority**: MEDIUM — Nice-to-have, enhances listening experience

---

### agent/h-export-sharing
**Focus**: Export playlists, share tracks, social integration
- [ ] Export playlist as M3U file
- [ ] Share playlist link (via text, email, social)
- [ ] Deep link handler for opening shared playlists
- [ ] Export as CSV for spreadsheet use
- [ ] Share individual tracks with metadata
**Files to touch**:
  - `lib/services/export_service.dart` (NEW)
  - `lib/screens/playlist_detail_screen.dart` (add share actions)
  - `lib/screens/now_playing_screen.dart` (add share track button)
  - `lib/services/deep_link_handler.dart` (NEW)
**Priority**: MEDIUM — Increases app virality and user engagement

---

### agent/i-analytics-insights
**Focus**: User stats, listening insights, recommendations
- [ ] Track play count, skip count, favorite count per track
- [ ] Show "Most Played" summary (weekly, monthly, all-time)
- [ ] Generate insights dashboard (genre breakdown, artist breakdown)
- [ ] Recommend "similar to" tracks based on listen history
- [ ] Persist analytics data with versioned keys
**Files to touch**:
  - `lib/services/analytics_service.dart` (NEW)
  - `lib/screens/insights_screen.dart` (NEW - dashboard)
  - `lib/models/music_models.dart` (extend Track with play count)
  - `lib/services/playback_controller.dart` (call analytics on track complete)
**Priority**: MEDIUM-LOW — Value-add for retention and discovery

---

### agent/j-accessibility-i18n
**Focus**: Internationalization, accessibility, inclusive design
- [ ] Add i18n support (English baseline + Spanish, French, German)
- [ ] WCAG 2.1 AA compliance: semantic labels, contrast, nav
- [ ] RTL support for Arabic/Hebrew (layout flipping)
- [ ] Screen reader testing and fixes
- [ ] High-contrast theme option
- [ ] Font scaling support
**Files to touch**:
  - `lib/l10n/` (NEW - localization files)
  - `lib/theme/app_theme.dart` (add high-contrast variant)
  - `lib/screens/main_shell.dart` (semantic labels)
  - `lib/main.dart` (configure localization delegates)
**Priority**: HIGH — Legal, ethical, and expands addressable market

---

## Merge Strategy

```
main (production-ready)
├── sprint/current (staging for next release)
│   ├── pulled from: agent/f, agent/g, agent/h, agent/i, agent/j
│   └── tested as integrated whole before merge to main
├── agent/f-offline-caching → sprint/current
├── agent/g-audio-effects → sprint/current
├── agent/h-export-sharing → sprint/current
├── agent/i-analytics-insights → sprint/current
└── agent/j-accessibility-i18n → sprint/current
```

Each agent:
1. Works independently on their branch
2. Runs local tests (`flutter test`)
3. Runs analyzer (`flutter analyze`)
4. Creates PR to `sprint/current` with description
5. Integration testing happens on `sprint/current`
6. Once stable, entire `sprint/current` merges to `main`

---

## Execution Intent

**Parallel execution via CLI agents:**
```powershell
# Run all 10 agents in parallel (local development mode)
copilot agent run --agent f-offline-caching --mode local
copilot agent run --agent g-audio-effects --mode local
copilot agent run --agent h-export-sharing --mode local
copilot agent run --agent i-analytics-insights --mode local
copilot agent run --agent j-accessibility-i18n --mode local
```

Each agent works on their branch independently, commits, and can push without conflicts.

---

## Success Criteria

- [ ] All 5 agents complete initial work on their branches
- [ ] Each agent runs `flutter analyze` and `flutter test` cleanly
- [ ] PRs created to `sprint/current`
- [ ] `sprint/current` builds and runs without crashes
- [ ] Integration tests pass
- [ ] Merge to `main` and tag as release candidate
