import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/screens/online_search_screen.dart';
import '../test_helpers.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('online search shows fail-closed production messaging', (tester) async {
    await tester.pumpWidget(
      buildTestableApp(
        home: const OnlineSearchScreen(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Production-safe mode: fail-closed until official backend is configured'),
      findsOneWidget,
    );
    expect(find.textContaining('Sign in required'), findsOneWidget);
  });
}
