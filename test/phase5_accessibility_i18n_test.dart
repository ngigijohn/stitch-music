import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/models/music_models.dart';
import 'package:stitch_music/screens/home_screen.dart';
import 'package:stitch_music/screens/now_playing_screen.dart';
import 'package:stitch_music/screens/online_search_screen.dart';
import 'package:stitch_music/services/playback_controller.dart';

import 'test_helpers.dart';

Widget _buildScaledRtlApp({required Widget home, Locale? locale}) {
  return buildTestableApp(
    home: home,
    locale: locale,
    builder: (context, child) {
      final mediaQuery = MediaQuery.of(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.8)),
          child: child ?? const SizedBox.shrink(),
        ),
      );
    },
  );
}

void _seedNowPlaying() {
  PlaybackController.instance.debugSeedQueueForTests(
    queue: const [
      Track(
        id: 'phase5_track',
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
}

void main() {
  tearDown(() {
    PlaybackController.instance.debugResetStateForTests();
  });

  testWidgets('home remains stable under RTL and large text', (tester) async {
    await tester.pumpWidget(
      _buildScaledRtlApp(home: const HomeScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Open Online Search'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('now playing remains stable under RTL and large text', (tester) async {
    _seedNowPlaying();

    await tester.pumpWidget(
      _buildScaledRtlApp(home: const NowPlayingScreen()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Queue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('now playing volume sheet exposes semantics metadata', (tester) async {
    _seedNowPlaying();
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestableApp(home: const NowPlayingScreen()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final volumeFinder = find.text('Volume');
    await tester.ensureVisible(volumeFinder);
    await tester.tap(volumeFinder, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Playback volume' &&
            widget.properties.hint == 'Adjust just_audio output volume for the current session.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('now playing track actions expose button semantics', (tester) async {
    _seedNowPlaying();
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildTestableApp(home: const NowPlayingScreen()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byTooltip('Track actions'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Add to playlist' &&
            widget.properties.hint == 'Save the current track to one of your playlists.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('online search renders localized Spanish copy', (tester) async {
    await tester.pumpWidget(
      buildTestableApp(
        locale: const Locale('es'),
        home: const OnlineSearchScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Busqueda en linea (YouTube)'), findsOneWidget);
    expect(find.text('Buscar'), findsOneWidget);
  });
}
