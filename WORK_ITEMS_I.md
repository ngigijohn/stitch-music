# Agent I: Analytics & Insights - Work Items

**Branch**: `agent/i-analytics-insights`  
**Priority**: MEDIUM-LOW  
**Focus**: User stats, listening insights, recommendations  

## Completed ✅

None yet (just starting)

## Backlog 📋

### Tier 1: Analytics Service
- [ ] Create `lib/services/analytics_service.dart`
  - [ ] `TrackStats` model with play count, skip count, favorite count, total duration
  - [ ] `ListeningInsight` model (weekly, monthly, all-time aggregations)
  - [ ] Singleton `AnalyticsService` to track events
  - [ ] Methods: `recordPlay()`, `recordSkip()`, `recordFavorite()`
  - [ ] Get stats by time range (week, month, all-time)
  - [ ] Persist stats with versioned SharedPreferences keys
  - [ ] Tests: `test/services/analytics_service_test.dart`

### Tier 2: Update PlaybackController
- [ ] Integrate analytics into `lib/services/playback_controller.dart`
  - [ ] Call `analytics.recordPlay(track)` when track starts
  - [ ] Call `analytics.recordSkip(track)` when skipped or seeked past 30%
  - [ ] Call `analytics.recordFavorite(track)` when favorited/unfavorited

### Tier 3: Insights Dashboard Screen
- [ ] Create `lib/screens/insights_screen.dart`
  - [ ] Show "Most Played Tracks" (top 10, all-time + last month)
  - [ ] Genre/artist breakdown charts (pie chart or bar chart)
  - [ ] Total hours listened, average daily listens
  - [ ] Top artists with play percentages
  - [ ] Listening heatmap (by day of week, by time of day)

### Tier 4: Recommendations
- [ ] Create recommendation engine
  - [ ] Suggest similar tracks based on:
    - [ ] Co-occurrence (tracks often played together)
    - [ ] Genre/artist affinity (similar to most-played)
    - [ ] Random from unheard/rarely-played
  - [ ] Show "Discover for You" section on Home (future iteration)

### Tier 5: Export Analytics
- [ ] Add "Export Stats" option in insights
  - [ ] CSV export of all play counts
  - [ ] Summary PDF with charts and insights

## Testing Checklist

- [ ] Unit tests for `AnalyticsService` (record, retrieve, aggregate)
- [ ] Widget test for insights dashboard
- [ ] Integration test: record plays, verify stats update
- [ ] Time-range filtering tests (week vs month vs all-time)
- [ ] Analyzer: `flutter analyze` clean
- [ ] Tests: `flutter test` all pass

## File Changes Summary

| File | Change | Reason |
|------|--------|--------|
| `lib/services/analytics_service.dart` | NEW | Analytics tracking |
| `lib/services/playback_controller.dart` | MODIFY | Record events |
| `lib/screens/insights_screen.dart` | NEW | Dashboard UI |
| `lib/models/music_models.dart` | MODIFY | Add TrackStats |
| `test/services/analytics_service_test.dart` | NEW | Analytics tests |

## Merge Criteria

Before submitting PR to `sprint/current`:
- ✅ Analyzer clean
- ✅ All tests passing
- ✅ Analytics tracked accurately (no double-counts)
- ✅ Insights dashboard loads quickly
- ✅ Manual device test: play songs, view insights, verify stats
- ✅ Commit message: `feat(analytics): add listening insights and stats dashboard`
