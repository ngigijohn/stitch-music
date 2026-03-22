import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/screens/settings_screen.dart';
import 'package:stitch_music/services/app_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test_helpers.dart';

void main() {
  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableApp(
        home: const SettingsScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('settings controls update and persist app preferences', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = AppPreferencesService.instance;
    await prefs.debugResetForTests();

    await pumpSettings(tester);

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'App language',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'High contrast mode',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Text size',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('settings_high_contrast_switch')));
    await tester.pumpAndSettle();
    expect(prefs.highContrast, isTrue);

    await tester.drag(find.byKey(const Key('settings_text_scale_slider')), const Offset(240, 0));
    await tester.pumpAndSettle();
    expect(prefs.textScale, greaterThan(1.0));

    await tester.tap(find.byKey(const Key('settings_language_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Spanish').last);
    await tester.pumpAndSettle();
    expect(prefs.localeCode, 'es');

    final textScaleBeforeRebuild = prefs.textScale;

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await pumpSettings(tester);

    expect(prefs.highContrast, isTrue);
    expect(prefs.localeCode, 'es');
    expect(prefs.textScale, textScaleBeforeRebuild);
  });
}
