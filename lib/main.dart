import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stitch_music/l10n/app_localizations.dart';
import 'package:stitch_music/services/app_preferences_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferencesService.instance.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const StitchMusicApp());
}

class StitchMusicApp extends StatelessWidget {
  const StitchMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = AppPreferencesService.instance;
    return AnimatedBuilder(
      animation: prefs,
      builder: (context, _) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: prefs.localeCode == null ? null : Locale(prefs.localeCode!),
          theme: buildAppTheme(highContrast: prefs.highContrast),
          home: const MainShell(),
        );
      },
    );
  }
}
