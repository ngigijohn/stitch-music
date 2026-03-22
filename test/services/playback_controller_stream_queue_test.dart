import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/models/music_models.dart';
import 'package:stitch_music/services/playback_controller.dart';
import 'package:stitch_music/services/streaming/stream_discovery_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('playback controller queues resolved stream candidates', () async {
    final controller = PlaybackController.instance;
    controller.debugResetStateForTests();

    const candidate = StreamCandidate(
      id: 'yt_phase4_001',
      title: 'Phase 4 Stream Track',
      artist: 'Remote Artist',
      provider: 'youtube',
      duration: Duration(minutes: 3, seconds: 30),
      requiresEntitlement: true,
    );

    await controller.addStreamCandidateToQueue(
      candidate: candidate,
      playbackUri: Uri.parse('https://demo.invalid/youtube/yt_phase4_001.mp3'),
      playNow: false,
    );

    expect(controller.queue, isNotEmpty);
    final queued = controller.queue.last;
    expect(queued.id, 'stream_youtube_yt_phase4_001');
    expect(queued.title, candidate.title);
    expect(queued.artist, candidate.artist);
    expect(queued.uri, 'https://demo.invalid/youtube/yt_phase4_001.mp3');
    expect(queued.duration, '3:30');

    controller.debugResetStateForTests();
  });

  test('playback controller keeps existing queue when adding stream candidates', () async {
    final controller = PlaybackController.instance;
    controller.loadQueueForTest(const [
      Track(
        id: 'local_01',
        title: 'Local Track',
        artist: 'Local Artist',
        album: 'Local Album',
        duration: '2:20',
        durationMs: 140000,
        uri: 'file:///tmp/local.mp3',
        filePath: '/tmp/local.mp3',
      ),
    ]);

    const candidate = StreamCandidate(
      id: 'yt_phase4_002',
      title: 'Second Stream Track',
      artist: 'Remote Artist',
      provider: 'youtube',
      requiresEntitlement: true,
    );

    await controller.addStreamCandidateToQueue(
      candidate: candidate,
      playbackUri: Uri.parse('https://demo.invalid/youtube/yt_phase4_002.mp3'),
      playNow: false,
    );

    expect(controller.queue.length, 2);
    expect(controller.queue.first.id, 'local_01');
    expect(controller.queue.last.id, 'stream_youtube_yt_phase4_002');

    controller.debugResetStateForTests();
  });
}
