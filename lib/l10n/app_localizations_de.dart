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

  @override
  String get homeAppBarTitle => 'The Sonic Gallery';

  @override
  String get homeOpenQuickActions => 'Schnellaktionen offnen';

  @override
  String get homeQaSettings => 'Einstellungen';

  @override
  String get homeQaSettingsSubtitle => 'Audio, Lokalisierung und App-Steuerung';

  @override
  String get homeQaCacheOffline => 'Cache & Offline';

  @override
  String get homeQaCacheOfflineSubtitle =>
      'Fixierte Tracks, Offline-Modus und Cache-Grosse';

  @override
  String get homeQaInsights => 'Statistiken';

  @override
  String get homeQaInsightsSubtitle => 'Wiedergabe-Statistiken und Hortrends';

  @override
  String get homeQaProfile => 'Profil';

  @override
  String get homeQaProfileSubtitle => 'Profil-Hub und Kontoaktionen offnen';

  @override
  String get homeOnlineDiscoveryTitle => 'Online-Entdeckung';

  @override
  String get homeOnlineDiscoveryDescription =>
      'Erkunde die YouTube-Suche im Demo-Modus, wahrend die offizielle API-Integration blockiert bleibt.';

  @override
  String get homeOnlineDiscoveryChipDemo => 'Demo-Ergebnisse';

  @override
  String get homeOnlineDiscoveryChipEntitlement => 'Berechtigungs-Banner';

  @override
  String get homeOnlineDiscoveryChipPolicy => 'Richtlinienkonform';

  @override
  String get homeOpenOnlineSearch => 'Online-Suche offnen';

  @override
  String get homeNoPlaybackYet => 'Wiedergabe ist hier noch nicht aktiviert.';

  @override
  String get homeHeroReadyToPlay => 'BEREIT ZUM ABSPIELEN';

  @override
  String get homeHeroNowPlayingBadge => 'WIRD ABGESPIELT';

  @override
  String get homeHeroDefaultTitle => 'Starte deine Sitzung';

  @override
  String get homeHeroDefaultSubtitle =>
      'Spiele etwas aus deiner Mediathek und der aktuelle Track erscheint hier.';

  @override
  String get homeHeroOpenPlayer => 'Player offnen';

  @override
  String get homeHeroResume => 'Fortsetzen';

  @override
  String get homeRecentPlaysTitle => 'Zuletzt gespielt';

  @override
  String get homeRecentPlaysEmpty => 'Keine lokalen Wiedergaben vorhanden';

  @override
  String get homeRecentPlaysEmptySubtitle =>
      'Spiele etwas aus deiner Mediathek und es erscheint hier.';

  @override
  String get homeFavoriteTracksTitle => 'Lieblingstracks';

  @override
  String get homeFavoriteTracksEmpty => 'Noch keine Favoriten';

  @override
  String get homeFavoriteTracksEmptySubtitle =>
      'Tippe in Jetzt lauft auf das Herz, um deine Lieblingstracks zu speichern.';

  @override
  String get homeRecentSearchesTitle => 'Letzte Online-Suchen';

  @override
  String get homeRecentSearchesEmpty => 'Noch keine Online-Suchen';

  @override
  String get homeRecentSearchesEmptySubtitle =>
      'Starte eine Suche in Online-Entdeckung und sie erscheint hier.';

  @override
  String get homeSearchDemoMode => 'Demo-Modus';

  @override
  String get homeSearchSafeMode => 'Sicherer Modus';

  @override
  String homeSearchResultCount(int count) {
    return '$count Ergebnisse';
  }

  @override
  String get homeDailyMixesTitle => 'Tagliche Mixes';

  @override
  String get homeSeeAll => 'Alle anzeigen';

  @override
  String get homeNewReleasesTitle => 'Neue Veroffentlichungen';

  @override
  String get homeAlbumOfWeek => 'Album der Woche';

  @override
  String get homeExploreAlbum => 'Album erkunden';

  @override
  String get nowPlayingNothingPlaying => 'Es wird nichts abgespielt.';

  @override
  String get nowPlayingFromDevice => 'WIEDERGABE VOM GERAT';

  @override
  String get nowPlayingCollapsePlayer => 'Player minimieren';

  @override
  String get nowPlayingTrackActionsTooltip => 'Track-Aktionen';

  @override
  String get nowPlayingAddToFavorites => 'Zu Favoriten hinzufugen';

  @override
  String get nowPlayingRemoveFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get nowPlayingPause => 'Wiedergabe pausieren';

  @override
  String get nowPlayingResumeSemantic => 'Wiedergabe fortsetzen';

  @override
  String get nowPlayingVolumeLabel => 'Lautstarke';

  @override
  String get nowPlayingSpeedLabel => 'Geschwindigkeit';

  @override
  String get nowPlayingEqLabel => 'EQ';

  @override
  String get nowPlayingShareLabel => 'Teilen';

  @override
  String get nowPlayingDevicesLabel => 'Gerate';

  @override
  String get nowPlayingQueueLabel => 'Warteschlange';

  @override
  String get nowPlayingCopyTrackInfo => 'Track-Info kopieren';

  @override
  String get nowPlayingCopyQueueLabel =>
      'Gesamte Warteschlange als Trackliste kopieren';

  @override
  String nowPlayingQueueCount(int count) {
    return '$count Tracks in der aktuellen Warteschlange';
  }

  @override
  String get nowPlayingCopiedToClipboard =>
      'Track-Info in die Zwischenablage kopiert';

  @override
  String get nowPlayingQueueCopied =>
      'Warteschlange in die Zwischenablage kopiert';

  @override
  String get nowPlayingThisDevice => 'Dieses Gerat';

  @override
  String get nowPlayingThisDeviceSubtitle =>
      'Die Wiedergabe bleibt auf dem aktiven Telefonausgang.';

  @override
  String get nowPlayingBluetooth => 'Bluetooth oder Cast-Route';

  @override
  String get nowPlayingBluetoothSubtitle =>
      'Verwende den System-Medienausgangs-Wahler, um die Wiedergabe zu verschieben. Stitch Music folgt der Systemroute.';

  @override
  String get nowPlayingVolumeSheetTitle => 'Wiedergabelautstarke';

  @override
  String get nowPlayingVolumeSheetSubtitle =>
      'Passe die just_audio-Ausgabelautstarke fur die aktuelle Sitzung an.';

  @override
  String get nowPlayingSpeedSheetTitle => 'Wiedergabegeschwindigkeit';

  @override
  String get nowPlayingSpeedSheetSubtitle =>
      'Verlangsame fur Details oder beschleunige fur die Ubersicht.';

  @override
  String get nowPlayingRemoveFavorite => 'Favorit entfernen';

  @override
  String get nowPlayingAddFavorite => 'Favorit hinzufugen';

  @override
  String get nowPlayingFavoriteSubtitle =>
      'Diesen Track in deiner Favoriten-Sektion anheften.';

  @override
  String get nowPlayingAddToPlaylist => 'Zur Wiedergabeliste';

  @override
  String get nowPlayingAddToPlaylistSubtitle =>
      'Den aktuellen Track in einer deiner Wiedergabelisten speichern.';

  @override
  String get nowPlayingShareTrack => 'Track teilen';

  @override
  String get nowPlayingShareTrackSubtitle =>
      'Track-Details oder aktive Warteschlange kopieren.';

  @override
  String get nowPlayingOpenInsights => 'Statistiken offnen';

  @override
  String get nowPlayingOpenInsightsSubtitle =>
      'Aktuelle Analysen und Hortrends anzeigen.';

  @override
  String get nowPlayingOpenSettings => 'Einstellungen offnen';

  @override
  String get nowPlayingOpenSettingsSubtitle =>
      'Zum EQ und den App-Steuerungen springen.';

  @override
  String get nowPlayingNoPlaylistsCreate =>
      'Noch keine Wiedergabelisten. Erstelle eine im Wiedergabelisten-Tab.';

  @override
  String nowPlayingAddedToPlaylist(String name) {
    return 'Zu \"$name\" hinzugefugt';
  }

  @override
  String get insightsTitle => 'Statistiken';

  @override
  String get insightsListeningHabits => 'HORGEWOHNHEITEN';

  @override
  String get insightsTopTracks => 'TOP-TRACKS';

  @override
  String get insightsTopArtists => 'TOP-KUNSTLER';

  @override
  String get insightsTotalPlays => 'Wiedergaben insgesamt';

  @override
  String get insightsListened => 'Gehort';

  @override
  String get insightsInLibrary => 'In Mediathek';

  @override
  String get insightsFavorites => 'Favoriten';

  @override
  String get insightsSkipRate => 'Skip-Rate';

  @override
  String get insightsSkipRateNoData => 'Noch keine Daten';

  @override
  String get insightsSkipRateLow => 'Niedrig — du horst zu Ende 🎯';

  @override
  String get insightsSkipRateModerate => 'Mittel — ziemlich wahlerisch';

  @override
  String get insightsSkipRateHigh => 'Hoch — viele Skips';

  @override
  String get insightsLast7Days => 'Letzte 7 Tage';

  @override
  String get insightsDayMon => 'Mo';

  @override
  String get insightsDayTue => 'Di';

  @override
  String get insightsDayWed => 'Mi';

  @override
  String get insightsDayThu => 'Do';

  @override
  String get insightsDayFri => 'Fr';

  @override
  String get insightsDaySat => 'Sa';

  @override
  String get insightsDaySun => 'So';

  @override
  String get insightsNoTopTracks =>
      'Spiele einige Tracks, um deine Top-Tracks zu sehen';

  @override
  String get insightsNoTopArtists => 'Bald verfugbar — spiele mehr Tracks';

  @override
  String insightsMinPlayed(int count) {
    return '$count Min gehort';
  }

  @override
  String get insightsPlaySingular => 'Wiedergabe';

  @override
  String get insightsPlayPlural => 'Wiedergaben';

  @override
  String get insightsClearStats => 'Alle Statistiken loschen';

  @override
  String get insightsClearTitle => 'Alle Statistiken loschen?';

  @override
  String get insightsClearContent =>
      'Dadurch werden alle Wiedergabeverlaufe und Analysedaten entfernt. Ihre Mediathek, Wiedergabelisten und Favoriten sind nicht betroffen.';

  @override
  String get insightsCancelButton => 'Abbrechen';

  @override
  String get insightsClearButton => 'Loschen';

  @override
  String get playlistsTitle => 'Wiedergabelisten';

  @override
  String get playlistsSaveQueue => 'Warteschlange speichern';

  @override
  String playlistsTrackCount(int count) {
    return '$count Tracks';
  }

  @override
  String get playlistsRenameTooltip => 'Umbenennen';

  @override
  String get playlistsDeleteTooltip => 'Wiedergabeliste loschen';

  @override
  String get playlistsPlayButton => 'Abspielen';

  @override
  String get playlistsEmptyTitle => 'Noch keine Wiedergabelisten';

  @override
  String get playlistsEmptySubtitle =>
      'Spiele Songs aus deiner Mediathek und speichere dann die Warteschlange als Wiedergabeliste.';

  @override
  String get playlistsCreateFromQueue => 'Aus Warteschlange erstellen';

  @override
  String get playlistsCreateTitle => 'Wiedergabeliste erstellen';

  @override
  String get playlistsNameHint => 'Name der Wiedergabeliste';

  @override
  String get playlistsCancelButton => 'Abbrechen';

  @override
  String get playlistsSaveButton => 'Speichern';

  @override
  String get playlistsQueueEmpty =>
      'Warteschlange ist leer. Spiele zuerst etwas.';

  @override
  String playlistsSaved(String name) {
    return '\"$name\" gespeichert';
  }

  @override
  String get playlistsRenameTitle => 'Wiedergabeliste umbenennen';

  @override
  String get onlineSearchTitle => 'Online-Suche (YouTube)';

  @override
  String get onlineSearchDiscoveryNote =>
      'Nur Entdeckung. Wiedergabe bleibt gesperrt bis offizielle API-Authentifizierung und Berechtigung verfugbar sind.';

  @override
  String get onlineSearchProviderUnavailable =>
      'Anbieter-Konfiguration nicht verfugbar.';

  @override
  String get onlineSearchEntitlementRequired =>
      'Berechtigung fur diesen Track erforderlich.';

  @override
  String get onlineSearchUriUnavailable =>
      'Wiedergabe-URI nicht verfugbar. Backend bleibt gesperrt.';

  @override
  String onlineSearchPlayingNow(String title) {
    return '\"$title\" wird jetzt abgespielt.';
  }

  @override
  String onlineSearchAddedToQueue(String title) {
    return '\"$title\" zur Warteschlange hinzugefugt.';
  }

  @override
  String get onlineSearchRefreshEntitlement => 'Berechtigung aktualisieren';

  @override
  String get onlineSearchDemoModeLabel =>
      'Demo-Modus: simulierte Anbieter-Ergebnisse fur UI-Tests';

  @override
  String get onlineSearchProductionModeLabel =>
      'Produktionssicherer Modus: gesperrt bis offizielles Backend konfiguriert ist';

  @override
  String get onlineSearchHint => 'Kunstler, Songs, Kanale suchen...';

  @override
  String get onlineSearchButton => 'Suchen';

  @override
  String get onlineSearchEntitlementUnknown => 'Berechtigung unbekannt';

  @override
  String get onlineSearchEntitlementUnknownBody =>
      'Berechtigungsstatus des Anbieters konnte nicht ermittelt werden.';

  @override
  String get onlineSearchSignInRequired => 'Anmeldung erforderlich';

  @override
  String get onlineSearchSignInRequiredBody =>
      'Bitte melde dich mit dem offiziellen Anbieter-Flow an.';

  @override
  String get onlineSearchPremiumRequired => 'Premium erforderlich';

  @override
  String get onlineSearchPremiumRequiredBody =>
      'Das aktuelle Kontoniveau erlaubt keine In-App-Wiedergabe.';

  @override
  String get onlineSearchUnavailableInRegion =>
      'In dieser Region nicht verfugbar';

  @override
  String get onlineSearchUnavailableInRegionBody =>
      'Streaming ist fur deine Region eingeschrankt.';

  @override
  String get onlineSearchEntitled => 'Berechtigt';

  @override
  String get onlineSearchEntitledBody =>
      'Konto scheint fur Anbieter-Wiedergabepruafungen qualifiziert.';

  @override
  String get onlineSearchNoCatalog =>
      'Durchsuche den Online-Katalog, um Tracks zu entdecken.';

  @override
  String get onlineSearchNoResults => 'Keine Ergebnisse gefunden.';

  @override
  String get onlineSearchLockedBadge => 'Gesperrt';

  @override
  String get onlineSearchOpenBadge => 'Frei';

  @override
  String get onlineSearchAddButton => 'Hinzufugen';

  @override
  String get onlineSearchPlayButton => 'Abspielen';
}
