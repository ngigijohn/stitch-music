import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/l10n/app_localizations.dart';
import 'package:stitch_music/screens/profile_screen.dart';
import 'package:stitch_music/theme/app_theme.dart';

void main() {
  Future<void> pumpProfile(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Profile screen routes settings and history actions', (tester) async {
    await pumpProfile(tester);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Listening History'));
    await tester.pumpAndSettle();
    expect(find.text('Listening History'), findsOneWidget);
  });
}