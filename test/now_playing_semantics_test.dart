import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/models/music_models.dart';
import 'package:stitch_music/screens/now_playing_screen.dart';
import 'package:stitch_music/services/playback_controller.dart';
import 'package:stitch_music/theme/app_theme.dart';

void main() {
  testWidgets('now playing exposes semantics for key action controls', (tester) async {
    final playback = PlaybackController.instance;
    playback.debugSeedQueueForTests(
      queue: const [
        Track(
          id: 'test_track_1',
          title: 'Test Signal',
          artist: 'QA Artist',
          album: 'Verification',
          duration: '4:00',
          durationMs: 240000,
          uri: 'file:///dev/null',
          filePath: '/dev/null',
        ),
      ],
      currentIndex: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        home: const NowPlayingScreen(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Add to favorites',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Volume',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Speed',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'EQ',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Devices',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Queue',
      ),
      findsOneWidget,
    );

    playback.debugResetStateForTests();
  });
}
