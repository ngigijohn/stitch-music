import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/services/youtube_service.dart';

void main() {
  group('YouTubeService.searchMusic', () {
    test('returns empty list for blank query', () async {
      final results = await YouTubeService.searchMusic('  ', 'fake-key');
      expect(results, isEmpty);
    });

    test('throws YouTubeServiceException when api key is empty', () async {
      await expectLater(
        YouTubeService.searchMusic('lofi beats', ''),
        throwsA(isA<YouTubeServiceException>()),
      );
    });
  });

  group('YouTubeServiceException', () {
    test('toString contains the message', () {
      const ex = YouTubeServiceException('API quota exceeded');
      expect(ex.toString(), contains('API quota exceeded'));
    });
  });
}
