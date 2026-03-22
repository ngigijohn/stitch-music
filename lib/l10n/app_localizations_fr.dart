// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Stitch Music';

  @override
  String get navHome => 'Accueil';

  @override
  String get navDiscover => 'Decouvrir';

  @override
  String get navLibrary => 'Bibliotheque';

  @override
  String get navProfile => 'Profil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDisplayName => 'Passionne de musique';

  @override
  String get profileSongs => 'Titres';

  @override
  String get profileArtists => 'Artistes';

  @override
  String get profileHours => 'Heures';

  @override
  String get profileEdit => 'Modifier le profil';

  @override
  String get profileHistory => 'Historique d\'ecoute';

  @override
  String get profileDownloads => 'Telechargements';

  @override
  String get profileSettings => 'Parametres';

  @override
  String get libraryTitle => 'Votre bibliotheque';

  @override
  String get libraryRescanTooltip => 'Relancer l\'analyse de l\'appareil';

  @override
  String get libraryOnlineSearchTooltip => 'Recherche en ligne (YouTube)';

  @override
  String get libraryOnlineSearchTitle => 'Recherche en ligne';

  @override
  String get libraryOnlineSearchDescription =>
      'Recherchez les resultats YouTube en mode demo ou securise.';

  @override
  String get openLabel => 'Ouvrir';

  @override
  String get librarySearchHint => 'Rechercher des titres, artistes, albums...';

  @override
  String get libraryFilterAll => 'Tout';

  @override
  String get libraryFilterSongs => 'Titres';

  @override
  String get libraryFilterAlbums => 'Albums';

  @override
  String get libraryFilterArtists => 'Artistes';

  @override
  String songsCount(int count) {
    return '$count titres';
  }

  @override
  String songsDetectedCount(int count) {
    return 'Titres detectes : $count';
  }

  @override
  String get mediaAccessGranted => 'Acces aux medias accorde';

  @override
  String get permissionPermanentlyDenied =>
      'Permission refusee de facon permanente';

  @override
  String get mediaPermissionRequired => 'Autorisation media requise';

  @override
  String get scanningStatus => 'Analyse en cours...';

  @override
  String get idleStatus => 'Inactif';

  @override
  String lastScan(String value) {
    return 'Derniere analyse : $value';
  }

  @override
  String get neverLabel => 'Jamais';

  @override
  String get retryLabel => 'Reessayer';

  @override
  String get openAppSettings => 'Ouvrir les parametres de l\'application';

  @override
  String get grantMusicPermission => 'Autoriser l\'acces a la musique';
}
