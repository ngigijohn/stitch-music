// Integration tests for CacheService: offline mode and track pinning.
//
// Each test starts from a clean state via SharedPreferences.setMockInitialValues({})
// combined with debugResetForTests(), which resets the singleton's in-memory
// fields and re-loads from the mock store — simulating a fresh app start.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/services/cache_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final cache = CacheService.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await cache.debugResetForTests();
  });

  // ── Offline mode ─────────────────────────────────────────────────────────────

  group('CacheService – offline mode', () {
    test('defaults to false', () {
      expect(cache.isOfflineMode, isFalse);
    });

    test('setOfflineMode(true) enables offline mode', () async {
      await cache.setOfflineMode(true);
      expect(cache.isOfflineMode, isTrue);
    });

    test('setOfflineMode toggles on then off', () async {
      await cache.setOfflineMode(true);
      expect(cache.isOfflineMode, isTrue);

      await cache.setOfflineMode(false);
      expect(cache.isOfflineMode, isFalse);
    });

    test('offline mode persists across re-init', () async {
      await cache.setOfflineMode(true);

      // Simulate app restart: reset in-memory state and reload from prefs.
      await cache.debugResetForTests();

      expect(cache.isOfflineMode, isTrue);
    });

    test('disabling offline mode persists across re-init', () async {
      await cache.setOfflineMode(true);
      await cache.setOfflineMode(false);

      await cache.debugResetForTests();

      expect(cache.isOfflineMode, isFalse);
    });
  });

  // ── Track pinning ─────────────────────────────────────────────────────────────

  group('CacheService – track pinning', () {
    test('no tracks are pinned by default', () {
      expect(cache.pinnedCount, 0);
      expect(cache.isPinned('track_1'), isFalse);
    });

    test('pinTrack makes isPinned return true', () async {
      await cache.pinTrack('track_1');

      expect(cache.isPinned('track_1'), isTrue);
      expect(cache.pinnedCount, 1);
    });

    test('pinTrack is idempotent – pinning twice keeps count at 1', () async {
      await cache.pinTrack('track_1');
      await cache.pinTrack('track_1');

      expect(cache.pinnedCount, 1);
    });

    test('unpinTrack makes isPinned return false', () async {
      await cache.pinTrack('track_1');
      await cache.unpinTrack('track_1');

      expect(cache.isPinned('track_1'), isFalse);
      expect(cache.pinnedCount, 0);
    });

    test('unpinTrack on an unpinned track is a no-op', () async {
      await cache.unpinTrack('nonexistent_track');

      expect(cache.pinnedCount, 0);
    });

    test('pinned tracks persist across re-init', () async {
      await cache.pinTrack('track_persist');

      await cache.debugResetForTests();

      expect(cache.isPinned('track_persist'), isTrue);
    });

    test('multiple tracks can be pinned independently', () async {
      await cache.pinTrack('a');
      await cache.pinTrack('b');
      await cache.pinTrack('c');

      expect(cache.isPinned('a'), isTrue);
      expect(cache.isPinned('b'), isTrue);
      expect(cache.isPinned('c'), isTrue);
      expect(cache.pinnedCount, 3);
    });

    test('pinnedIds returns an unmodifiable set', () async {
      await cache.pinTrack('track_1');

      expect(() => cache.pinnedIds.add('intruder'), throwsUnsupportedError);
    });
  });

  // ── togglePin ─────────────────────────────────────────────────────────────────

  group('CacheService – togglePin', () {
    test('togglePin pins an unpinned track', () async {
      expect(cache.isPinned('track_2'), isFalse);

      await cache.togglePin('track_2');

      expect(cache.isPinned('track_2'), isTrue);
    });

    test('togglePin unpins a pinned track', () async {
      await cache.pinTrack('track_3');

      await cache.togglePin('track_3');

      expect(cache.isPinned('track_3'), isFalse);
    });

    test('togglePin twice returns track to its original unpinned state', () async {
      await cache.togglePin('track_4');
      await cache.togglePin('track_4');

      expect(cache.isPinned('track_4'), isFalse);
    });
  });
}
