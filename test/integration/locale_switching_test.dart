// Integration tests for locale switching via AppPreferencesService and the
// Settings screen language dropdown.
//
// Each test resets the singleton with SharedPreferences.setMockInitialValues({})
// followed by debugResetForTests(), so tests are fully independent of each other.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/screens/settings_screen.dart';
import 'package:stitch_music/services/app_preferences_service.dart';
import '../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final prefs = AppPreferencesService.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await prefs.debugResetForTests();
  });

  // ── Service-level locale tests ────────────────────────────────────────────────

  group('AppPreferencesService – locale persistence', () {
    test('locale defaults to null (system)', () {
      expect(prefs.localeCode, isNull);
    });

    test('setLocaleCode stores the given code in memory', () async {
      await prefs.setLocaleCode('es');

      expect(prefs.localeCode, 'es');
    });

    test('locale persists across re-init (simulates app restart)', () async {
      await prefs.setLocaleCode('es');

      // Re-load from SharedPreferences, as on a real restart.
      await prefs.debugResetForTests();

      expect(prefs.localeCode, 'es');
    });

    test('switching from English to Spanish updates locale code', () async {
      await prefs.setLocaleCode('en');
      expect(prefs.localeCode, 'en');

      await prefs.setLocaleCode('es');

      expect(prefs.localeCode, 'es');
    });

    test('setting null resets locale back to system default', () async {
      await prefs.setLocaleCode('fr');
      await prefs.setLocaleCode(null);

      expect(prefs.localeCode, isNull);
    });

    test('all supported locale codes can be stored and retrieved', () async {
      for (final code in ['en', 'es', 'fr', 'de']) {
        await prefs.setLocaleCode(code);
        expect(prefs.localeCode, code, reason: 'Expected locale "$code" to be stored');
      }
    });
  });

  // ── Settings screen widget tests ──────────────────────────────────────────────

  group('Settings screen – language dropdown', () {
    testWidgets('language dropdown is present on the settings screen', (tester) async {
      await tester.pumpWidget(buildTestableApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_language_dropdown')), findsOneWidget);
    });

    testWidgets('selecting Spanish via dropdown sets localeCode to "es"', (tester) async {
      await tester.pumpWidget(buildTestableApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('settings_language_dropdown')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Spanish').last);
      await tester.pumpAndSettle();

      expect(prefs.localeCode, 'es');
    });

    testWidgets('dropdown value reflects locale already set on the service', (tester) async {
      await prefs.setLocaleCode('fr');

      await tester.pumpWidget(buildTestableApp(home: const SettingsScreen()));
      await tester.pumpAndSettle();

      final dropdown = tester.widget<DropdownButton<String?>>(
        find.byKey(const Key('settings_language_dropdown')),
      );
      expect(dropdown.value, 'fr');
    });
  });
}
