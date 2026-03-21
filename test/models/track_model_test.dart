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

  group('YouTubeVideoResult.fromJson', () {
    test('parses all fields from a valid API response item', () {
      final item = {
        'id': {'videoId': 'dQw4w9WgXcQ'},
        'snippet': {
          'title': 'Never Gonna Give You Up',
          'channelTitle': 'Rick Astley',
          'publishedAt': '2009-10-25T06:57:33Z',
          'thumbnails': {
            'medium': {
              'url': 'https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg',
            },
          },
        },
      };

      final result = YouTubeVideoResult.fromJson(item);

      expect(result.videoId, 'dQw4w9WgXcQ');
      expect(result.title, 'Never Gonna Give You Up');
      expect(result.channelTitle, 'Rick Astley');
      expect(result.publishedAt, '2009-10-25T06:57:33Z');
      expect(result.thumbnailUrl,
          'https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg');
    });

    test('falls back gracefully when fields are missing', () {
      final result = YouTubeVideoResult.fromJson({});

      expect(result.videoId, '');
      expect(result.title, 'Unknown Title');
      expect(result.channelTitle, 'Unknown Channel');
      expect(result.thumbnailUrl, '');
      expect(result.publishedAt, '');
    });
  });
}
