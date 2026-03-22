import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/l10n/app_localizations.dart';
import 'package:stitch_music/screens/settings_screen.dart';
import 'package:stitch_music/services/app_preferences_service.dart';
import 'package:stitch_music/theme/app_theme.dart';

void main() {
  testWidgets('settings remains usable under RTL and large text scale', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferencesService.instance;
    await prefs.debugResetForTests();
    await prefs.setTextScale(1.4);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: mq.copyWith(textScaler: const TextScaler.linear(1.4)),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        home: const SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('settings_language_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('settings_high_contrast_switch')), findsOneWidget);
    expect(find.byKey(const Key('settings_text_scale_slider')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('settings_reset_text_scale_button')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
