// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Stitch Music';

  @override
  String get navHome => 'Start';

  @override
  String get navDiscover => 'Entdecken';

  @override
  String get navLibrary => 'Mediathek';

  @override
  String get navProfile => 'Profil';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDisplayName => 'Musikfan';

  @override
  String get profileSongs => 'Songs';

  @override
  String get profileArtists => 'Kunstler';

  @override
  String get profileHours => 'Stunden';

  @override
  String get profileEdit => 'Profil bearbeiten';

  @override
  String get profileHistory => 'Horverlauf';

  @override
  String get profileDownloads => 'Downloads';

  @override
  String get profileSettings => 'Einstellungen';

  @override
  String get libraryTitle => 'Deine Mediathek';

  @override
  String get libraryRescanTooltip => 'Gerat erneut scannen';

  @override
  String get libraryOnlineSearchTooltip => 'Online-Suche (YouTube)';

  @override
  String get libraryOnlineSearchTitle => 'Online-Suche';

  @override
  String get libraryOnlineSearchDescription =>
      'Durchsuche YouTube-Entdeckungen im Demo- oder sicheren Modus.';

  @override
  String get openLabel => 'Offnen';

  @override
  String get librarySearchHint => 'Songs, Kunstler, Alben suchen...';

  @override
  String get libraryFilterAll => 'Alle';

  @override
  String get libraryFilterSongs => 'Songs';

  @override
  String get libraryFilterAlbums => 'Alben';

  @override
  String get libraryFilterArtists => 'Kunstler';

  @override
  String songsCount(int count) {
    return '$count Songs';
  }

  @override
  String songsDetectedCount(int count) {
    return 'Erkannte Songs: $count';
  }

  @override
  String get mediaAccessGranted => 'Medienzugriff gewahrt';

  @override
  String get permissionPermanentlyDenied => 'Berechtigung dauerhaft verweigert';

  @override
  String get mediaPermissionRequired => 'Medienberechtigung erforderlich';

  @override
  String get scanningStatus => 'Scan lauft...';

  @override
  String get idleStatus => 'Leerlauf';

  @override
  String lastScan(String value) {
    return 'Letzter Scan: $value';
  }

  @override
  String get neverLabel => 'Nie';

  @override
  String get retryLabel => 'Erneut versuchen';

  @override
  String get openAppSettings => 'App-Einstellungen offnen';

  @override
  String get grantMusicPermission => 'Musikberechtigung erteilen';

  @override
  String get settingsLanguageSection => 'Sprache';

  @override
  String get settingsLanguageLabel => 'App-Sprache';

  @override
  String get settingsLanguageSystem => 'Systemstandard';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageSpanish => 'Spanisch';

  @override
  String get settingsLanguageFrench => 'Franzosisch';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsAccessibilitySection => 'Barrierefreiheit';

  @override
  String get settingsHighContrastTitle => 'Hoher Kontrast';

  @override
  String get settingsHighContrastSubtitle =>
      'Erhoht den Kontrast fur Text und wichtige Oberflachen';

  @override
  String get settingsTextScaleTitle => 'Textgrosse';

  @override
  String get settingsTextScaleSubtitle => 'Skaliert Text in der gesamten App';

  @override
  String get settingsTextScaleReset => 'Textgrosse zurucksetzen';

  @override
  String get settingsAccessibilityRoadmapTitle =>
      'Weitere Barrierefreiheitsoptionen';

  @override
  String get settingsAccessibilityRoadmapSubtitle =>
      'Screenreader-Semantik, Fokus-Anpassungen und Verbesserungen fur Textskalierung sind in Arbeit';

  @override
  String get settingsGeneralSection => 'Allgemein';

  @override
  String get settingsOfflineTitle => 'Offline und Cache';

  @override
  String get settingsOfflineSubtitle =>
      'Pins, Cache-Limits und Offline-Verhalten verwalten';

  @override
  String get settingsAudioSection => 'Audioeffekte';

  @override
  String get settingsEqTitle => 'Equalizer';

  @override
  String get settingsEnabledLabel => 'Aktiv';

  @override
  String get settingsDisabledLabel => 'Deaktiviert';

  @override
  String get settingsPresetLabel => 'Voreinstellung';

  @override
  String get settingsCustomEqLabel => 'Benutzerdefinierter EQ';

  @override
  String get settingsResetEq => 'Auf Flat zurucksetzen';
}
