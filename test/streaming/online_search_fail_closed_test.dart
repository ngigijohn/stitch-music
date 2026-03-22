import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/screens/online_search_screen.dart';
import 'package:stitch_music/theme/app_theme.dart';

void main() {
  testWidgets('online search shows fail-closed production messaging', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
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
