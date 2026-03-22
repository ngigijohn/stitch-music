import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stitch_music/l10n/app_localizations.dart';
import 'package:stitch_music/theme/app_theme.dart';

/// Build a MaterialApp with localization support for testing
MaterialApp buildTestableApp({
  required Widget home,
  Locale? locale,
  TransitionBuilder? builder,
}) {
  return MaterialApp(
    theme: buildAppTheme(),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale ?? const Locale('en'),
    builder: builder,
    home: home,
  );
}
