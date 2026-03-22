import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/models/music_models.dart';
import 'package:stitch_music/screens/now_playing_screen.dart';
import 'package:stitch_music/screens/insights_screen.dart';
import 'package:stitch_music/screens/settings_screen.dart';
import 'package:stitch_music/services/playback_controller.dart';
import 'test_helpers.dart';

const _testTrack = Track(
  id: 'test_1',
  title: 'Test Track',
  artist: 'QA',
  album: 'Test',
  duration: '3:00',
  durationMs: 180000,
  uri: 'file:///dev/null',
  filePath: '/dev/null',
);

Future<void> _pumpNowPlaying(WidgetTester tester) async {
  await tester.pumpWidget(buildTestableApp(home: const NowPlayingScreen()));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() {
    PlaybackController.instance.debugSeedQueueForTests(
      queue: const [_testTrack],
      currentIndex: 0,
    );
  });

  tearDown(() {
    PlaybackController.instance.debugResetStateForTests();
  });

  // ── Track actions sheet ─────────────────────────────────────────────────────

  testWidgets('track actions sheet opens when more button is tapped',
      (tester) async {
    tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpNowPlaying(tester);

    await tester.tap(find.byTooltip('Track actions'));
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (w) => w is Text && (w.data == 'Add favorite' || w.data == 'Remove favorite'),
      ),
      findsOneWidget,
    );
  });

  testWidgets(
      'track actions sheet "Open insights" navigates to InsightsScreen',
      (tester) async {
    tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpNowPlaying(tester);

    await tester.tap(find.byTooltip('Track actions'));
    await tester.pumpAndSettle();

    final insightsTile = find.widgetWithText(ListTile, 'Open insights');
    expect(insightsTile, findsOneWidget);
    await tester.tap(insightsTile);
    await tester.pumpAndSettle();

    expect(find.byType(InsightsScreen), findsOneWidget);
  });

  testWidgets(
      'track actions sheet "Open settings" navigates to SettingsScreen',
      (tester) async {
    tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpNowPlaying(tester);

    await tester.tap(find.byTooltip('Track actions'));
    await tester.pumpAndSettle();

    final settingsTile = find.widgetWithText(ListTile, 'Open settings');
    expect(settingsTile, findsOneWidget);
    await tester.tap(settingsTile);
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  // ── Devices sheet ───────────────────────────────────────────────────────────

  testWidgets('devices sheet opens when Devices bottom bar button is tapped',
      (tester) async {
    tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpNowPlaying(tester);

    await tester.tap(find.text('Devices'));
    await tester.pumpAndSettle();

    expect(find.text('This device'), findsOneWidget);
  });

  // ── Volume sheet ────────────────────────────────────────────────────────────

  testWidgets('volume sheet opens when Volume pill is tapped', (tester) async {
    tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pumpNowPlaying(tester);

    await tester.tap(find.text('Volume'));
    await tester.pumpAndSettle();

    expect(find.text('Playback volume'), findsOneWidget);
  });
}
