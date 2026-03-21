import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/models/music_models.dart';

void main() {
  group('Track.fromMediaStoreMap', () {
    test('maps required fields and formats duration', () {
      final track = Track.fromMediaStoreMap({
        'id': 42,
        'title': 'Sunrise Echo',
        'artist': 'Luma',
        'album': 'Dawn',
        'duration': 245000,
        'uri': 'content://media/external/audio/media/42',
        'data': '/storage/emulated/0/Music/Sunrise Echo.mp3',
      });

      expect(track.id, '42');
      expect(track.title, 'Sunrise Echo');
      expect(track.artist, 'Luma');
      expect(track.album, 'Dawn');
      expect(track.durationMs, 245000);
      expect(track.duration, '4:05');
      expect(track.uri, 'content://media/external/audio/media/42');
      expect(track.filePath, '/storage/emulated/0/Music/Sunrise Echo.mp3');
      expect(track.songId, 42);
      expect(track.dominantColor, const Color(0xFF7C4DFF));
    });

    test('falls back when map values are missing or invalid', () {
      final track = Track.fromMediaStoreMap({'id': 'x'});

      expect(track.id, 'x');
      expect(track.title, 'Unknown Track');
      expect(track.artist, 'Unknown Artist');
      expect(track.album, 'Unknown Album');
      expect(track.duration, '0:00');
      expect(track.durationMs, 0);
      expect(track.songId, isNull);
    });
  });
}
