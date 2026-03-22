// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Stitch Music';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileDisplayName => 'Music Lover';

  @override
  String get profileSongs => 'Songs';

  @override
  String get profileArtists => 'Artists';

  @override
  String get profileHours => 'Hours';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileHistory => 'Listening History';

  @override
  String get profileDownloads => 'Downloads';

  @override
  String get profileSettings => 'Settings';

  @override
  String get libraryTitle => 'Your Library';

  @override
  String get libraryRescanTooltip => 'Rescan device';

  @override
  String get libraryOnlineSearchTooltip => 'Online search (YouTube)';

  @override
  String get libraryOnlineSearchTitle => 'Online Search';

  @override
  String get libraryOnlineSearchDescription =>
      'Search YouTube discovery results in demo or safe mode.';

  @override
  String get openLabel => 'Open';

  @override
  String get librarySearchHint => 'Search songs, artists, albums...';

  @override
  String get libraryFilterAll => 'All';

  @override
  String get libraryFilterSongs => 'Songs';

  @override
  String get libraryFilterAlbums => 'Albums';

  @override
  String get libraryFilterArtists => 'Artists';

  @override
  String songsCount(int count) {
    return '$count songs';
  }

  @override
  String songsDetectedCount(int count) {
    return 'Songs detected: $count';
  }

  @override
  String get mediaAccessGranted => 'Media access granted';

  @override
  String get permissionPermanentlyDenied => 'Permission permanently denied';

  @override
  String get mediaPermissionRequired => 'Media permission required';

  @override
  String get scanningStatus => 'Scanning...';

  @override
  String get idleStatus => 'Idle';

  @override
  String lastScan(String value) {
    return 'Last scan: $value';
  }

  @override
  String get neverLabel => 'Never';

  @override
  String get retryLabel => 'Retry';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get grantMusicPermission => 'Grant music permission';
}
