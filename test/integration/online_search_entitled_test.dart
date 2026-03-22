import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/screens/online_search_screen.dart';
import '../test_helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSearch(WidgetTester tester) async {
    await tester.pumpWidget(buildTestableApp(home: const OnlineSearchScreen()));
    await tester.pumpAndSettle();
  }

  // ── Demo mode label ─────────────────────────────────────────────────────────

  testWidgets('demo mode shows demo mode label by default', (tester) async {
    await pumpSearch(tester);

    expect(
      find.textContaining(
          'Demo mode: mocked provider results for UI testing'),
      findsOneWidget,
    );
  });

  // ── Production mode ─────────────────────────────────────────────────────────

  testWidgets('production mode shows fail-closed messaging after toggling switch',
      (tester) async {
    await pumpSearch(tester);

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
          'Production-safe mode: fail-closed until official backend is configured'),
      findsOneWidget,
    );
  });

  // ── Sign in required in production mode ─────────────────────────────────────

  testWidgets('production mode shows sign in required banner', (tester) async {
    await pumpSearch(tester);

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Sign in required'), findsOneWidget);
  });

  // ── Demo mode search results ─────────────────────────────────────────────────

  testWidgets('demo mode search returns results with Play buttons',
      (tester) async {
    await pumpSearch(tester);

    // Demo mode is on by default — type a query and submit.
    await tester.enterText(find.byType(TextField).first, 'test song');
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Play'), findsWidgets);
  });

  testWidgets('demo mode search results include Add buttons', (tester) async {
    await pumpSearch(tester);

    await tester.enterText(find.byType(TextField).first, 'test song');
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Add'), findsWidgets);
  });
}
