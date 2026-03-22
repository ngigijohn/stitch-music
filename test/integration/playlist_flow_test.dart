// Integration tests: playlist CRUD flow exercised entirely through
// PlaybackController (no platform channels needed for these unit-level tests).
//
// These tests validate the full lifecycle:
//   createPlaylistFromQueue → rename → add track → remove track → reorder → delete

import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/models/music_models.dart';
import 'package:stitch_music/services/playback_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

Track _fakeTrack(String id, String title) => Track(
      id: id,
      title: title,
      artist: 'Test Artist',
      album: 'Test Album',
      duration: '3:00',
      filePath: '/fake/$id.mp3',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PlaybackController ctrl;

  setUp(() async {
    // Use in-memory shared prefs to avoid polluting real storage.
    SharedPreferences.setMockInitialValues({});
    // Access the singleton — it is already constructed, so reset its internal
    // state via the test helper we expose via queue injection.
    ctrl = PlaybackController.instance;
  });

  group('Playlist CRUD', () {
    test('createPlaylistFromQueue builds a playlist with correct track IDs', () async {
      final tracks = [
        _fakeTrack('t1', 'Song One'),
        _fakeTrack('t2', 'Song Two'),
        _fakeTrack('t3', 'Song Three'),
      ];
      ctrl.loadQueueForTest(tracks);

      await ctrl.createPlaylistFromQueue('My Mix');

      expect(ctrl.playlists.length, 1);
      final pl = ctrl.playlists.first;
      expect(pl.name, 'My Mix');
      expect(pl.trackIds, containsAll(['t1', 't2', 't3']));
    });

    test('renamePlaylist updates the playlist name', () async {
      ctrl.loadQueueForTest([_fakeTrack('t1', 'A'), _fakeTrack('t2', 'B')]);
      await ctrl.createPlaylistFromQueue('Original');
      final id = ctrl.playlists.first.id;

      await ctrl.renamePlaylist(id, 'Renamed');

      expect(ctrl.playlists.first.name, 'Renamed');
    });

    test('addTrackToPlaylist appends a new track ID', () async {
      ctrl.loadQueueForTest([_fakeTrack('t1', 'A')]);
      await ctrl.createPlaylistFromQueue('Test');
      final id = ctrl.playlists.first.id;

      await ctrl.addTrackToPlaylist(id, 't99');

      expect(ctrl.playlists.first.trackIds, contains('t99'));
    });

    test('addTrackToPlaylist does not duplicate an existing track', () async {
      ctrl.loadQueueForTest([_fakeTrack('t1', 'A')]);
      await ctrl.createPlaylistFromQueue('Test');
      final id = ctrl.playlists.first.id;

      await ctrl.addTrackToPlaylist(id, 't1');
      await ctrl.addTrackToPlaylist(id, 't1');

      expect(ctrl.playlists.first.trackIds.where((x) => x == 't1').length, 1);
    });

    test('removeTrackFromPlaylist drops the specified track ID', () async {
      ctrl.loadQueueForTest([_fakeTrack('t1', 'A'), _fakeTrack('t2', 'B')]);
      await ctrl.createPlaylistFromQueue('Test');
      final id = ctrl.playlists.first.id;

      await ctrl.removeTrackFromPlaylist(id, 't1');

      expect(ctrl.playlists.first.trackIds, isNot(contains('t1')));
      expect(ctrl.playlists.first.trackIds, contains('t2'));
    });

    test('reorderPlaylistTrack moves track from index 0 to index 2', () async {
      ctrl.loadQueueForTest([
        _fakeTrack('a', 'A'),
        _fakeTrack('b', 'B'),
        _fakeTrack('c', 'C'),
      ]);
      await ctrl.createPlaylistFromQueue('Reorder Test');
      final id = ctrl.playlists.first.id;

      // Move 'a' (index 0) to end (index 3 before adjustment = index 2 after)
      await ctrl.reorderPlaylistTrack(id, 0, 3);

      final ids = ctrl.playlists.first.trackIds;
      expect(ids, ['b', 'c', 'a']);
    });

    test('deletePlaylist removes it from the list', () async {
      ctrl.loadQueueForTest([_fakeTrack('t1', 'A')]);
      await ctrl.createPlaylistFromQueue('Delete Me');
      final id = ctrl.playlists.first.id;

      await ctrl.deletePlaylist(id);

      expect(ctrl.playlists, isEmpty);
    });
  });

  group('Playlist model serialization', () {
    test('Playlist roundtrips through toMap/fromMap', () {
      final original = Playlist(
        id: 'pl_1',
        name: 'Weekend Vibes',
        trackIds: ['t1', 't2', 't3'],
        createdAt: DateTime(2026, 3, 21, 10, 0),
      );

      final map = original.toMap();
      final restored = Playlist.fromMap(map);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.trackIds, original.trackIds);
    });

    test('Playlist.copyWith preserves unchanged fields', () {
      final original = Playlist(
        id: 'pl_2',
        name: 'Old Name',
        trackIds: ['x', 'y'],
        createdAt: DateTime(2026, 1, 1),
      );

      final updated = original.copyWith(name: 'New Name');

      expect(updated.name, 'New Name');
      expect(updated.id, original.id);
      expect(updated.trackIds, original.trackIds);
    });
  });
}
