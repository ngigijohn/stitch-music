import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/screens/profile_screen.dart';
import 'test_helpers.dart';

void main() {
  Future<void> pumpProfile(WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableApp(
        home: const ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Profile screen routes settings and history actions', (tester) async {
    await pumpProfile(tester);

    final settingsTile = find.widgetWithText(ListTile, 'Settings');
    await tester.ensureVisible(settingsTile);
    await tester.tap(settingsTile);
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded).first);
    await tester.pumpAndSettle();

    final historyTile = find.widgetWithText(ListTile, 'Listening History');
    await tester.ensureVisible(historyTile);
    await tester.tap(historyTile);
    await tester.pumpAndSettle();
    expect(find.text('Listening History'), findsOneWidget);
  });
}