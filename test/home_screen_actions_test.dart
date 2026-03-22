import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stitch_music/screens/home_screen.dart';
import 'test_helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(buildTestableApp(home: const HomeScreen()));
    // Allow initState/async work to settle without running forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Finder get _quickActionsBtn => find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Open quick actions',
      );

  Future<void> _openQuickActions(WidgetTester tester) async {
    final btn = _quickActionsBtn;
    expect(btn, findsOneWidget);
    await tester.tap(btn);
    await tester.pumpAndSettle();
  }

  // ── Sheet presence ──────────────────────────────────────────────────────────

  testWidgets('quick actions sheet opens on action button tap', (tester) async {
    await pumpHome(tester);
    await _openQuickActions(tester);

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Cache & Offline'), findsOneWidget);
    expect(find.text('Insights'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });

  // ── Quick action navigation ─────────────────────────────────────────────────

  testWidgets('quick action Settings navigates to SettingsScreen',
      (tester) async {
    await pumpHome(tester);
    await _openQuickActions(tester);

    final tile = find.widgetWithText(ListTile, 'Settings').first;
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    // SettingsScreen has an AppBar/heading with 'Settings'.
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('quick action Cache & Offline navigates to CacheSettingsScreen',
      (tester) async {
    await pumpHome(tester);
    await _openQuickActions(tester);

    final tile = find.widgetWithText(ListTile, 'Cache & Offline').first;
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    // CacheSettingsScreen's AppBar title is 'Offline & Cache'.
    expect(find.text('Offline & Cache'), findsOneWidget);
  });

  testWidgets('quick action Insights navigates to InsightsScreen',
      (tester) async {
    await pumpHome(tester);
    await _openQuickActions(tester);

    final tile = find.widgetWithText(ListTile, 'Insights').first;
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    // InsightsScreen's AppBar title is the l10n string 'Insights'.
    expect(find.text('Insights'), findsWidgets);
  });

  testWidgets('quick action Profile navigates to ProfileScreen', (tester) async {
    await pumpHome(tester);
    await _openQuickActions(tester);

    final tile = find.widgetWithText(ListTile, 'Profile').first;
    await tester.ensureVisible(tile);
    await tester.tap(tile);
    await tester.pumpAndSettle();

    // ProfileScreen shows 'Profile' in its heading area.
    expect(find.text('Profile'), findsWidgets);
  });

  // ── Daily Mixes ─────────────────────────────────────────────────────────────

  testWidgets('Daily Mixes "See All" button navigates to DailyMixesScreen',
      (tester) async {
    await pumpHome(tester);

    final seeAllBtn = find.text('See All');
    await tester.ensureVisible(seeAllBtn);
    await tester.tap(seeAllBtn);
    await tester.pumpAndSettle();

    // DailyMixesScreen's AppBar title is 'Daily Mixes'.
    expect(find.text('Daily Mixes'), findsWidgets);
  });
}
