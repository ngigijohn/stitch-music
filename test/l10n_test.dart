import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/l10n/app_localizations.dart';

void main() {
  test('supported locales load generated translations', () async {
    const locales = [
      Locale('en'),
      Locale('es'),
      Locale('fr'),
      Locale('de'),
    ];

    for (final locale in locales) {
      expect(AppLocalizations.supportedLocales, contains(locale));

      final l10n = await AppLocalizations.delegate.load(locale);
      expect(l10n.appTitle, 'Stitch Music');
      expect(l10n.navLibrary, isNotEmpty);
      expect(l10n.profileSettings, isNotEmpty);
      expect(l10n.homeOnlineDiscoveryTitle, isNotEmpty);
      expect(l10n.homePlayMore, isNotEmpty);
      expect(l10n.nowPlayingSeekLabel, isNotEmpty);
      expect(l10n.playlistsDefaultName('10:30'), isNotEmpty);
    }
  });
}