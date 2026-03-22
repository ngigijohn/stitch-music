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

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageLabel => 'App language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Spanish';

  @override
  String get settingsLanguageFrench => 'French';

  @override
  String get settingsLanguageGerman => 'German';

  @override
  String get settingsAccessibilitySection => 'Accessibility';

  @override
  String get settingsHighContrastTitle => 'High contrast mode';

  @override
  String get settingsHighContrastSubtitle =>
      'Increase contrast for text and key surfaces';

  @override
  String get settingsTextScaleTitle => 'Text size';

  @override
  String get settingsTextScaleSubtitle => 'Scale text across the app';

  @override
  String get settingsTextScaleReset => 'Reset text size';

  @override
  String get settingsAccessibilityRoadmapTitle => 'More accessibility controls';

  @override
  String get settingsAccessibilityRoadmapSubtitle =>
      'Screen reader semantics, focus tuning, and text scaling refinements are in progress';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsOfflineTitle => 'Offline and cache';

  @override
  String get settingsOfflineSubtitle =>
      'Manage pins, cache limits, and offline behavior';

  @override
  String get settingsAudioSection => 'Audio effects';

  @override
  String get settingsEqTitle => 'Equalizer';

  @override
  String get settingsEnabledLabel => 'Enabled';

  @override
  String get settingsDisabledLabel => 'Disabled';

  @override
  String get settingsPresetLabel => 'Preset';

  @override
  String get settingsCustomEqLabel => 'Custom EQ';

  @override
  String get settingsResetEq => 'Reset to Flat';

  @override
  String get homeAppBarTitle => 'The Sonic Gallery';

  @override
  String get homeOpenQuickActions => 'Open quick actions';

  @override
  String get homeQaSettings => 'Settings';

  @override
  String get homeQaSettingsSubtitle => 'Audio, localization, and app controls';

  @override
  String get homeQaCacheOffline => 'Cache & Offline';

  @override
  String get homeQaCacheOfflineSubtitle =>
      'Pinned tracks, offline mode, and cache size';

  @override
  String get homeQaInsights => 'Insights';

  @override
  String get homeQaInsightsSubtitle =>
      'Playback stats and recent listening trends';

  @override
  String get homeQaProfile => 'Profile';

  @override
  String get homeQaProfileSubtitle =>
      'Open the profile hub and account actions';

  @override
  String get homeOnlineDiscoveryTitle => 'Online Discovery';

  @override
  String get homeOnlineDiscoveryDescription =>
      'Explore the YouTube search experience in demo mode while official API integration stays fail-closed.';

  @override
  String get homeOnlineDiscoveryChipDemo => 'Demo Results';

  @override
  String get homeOnlineDiscoveryChipEntitlement => 'Entitlement Banners';

  @override
  String get homeOnlineDiscoveryChipPolicy => 'Policy-Compliant';

  @override
  String get homeOpenOnlineSearch => 'Open Online Search';

  @override
  String get homeNoPlaybackYet => 'No playback is enabled here yet.';

  @override
  String get homeHeroReadyToPlay => 'READY TO PLAY';

  @override
  String get homeHeroNowPlayingBadge => 'NOW PLAYING';

  @override
  String get homeHeroDefaultTitle => 'Start Your Session';

  @override
  String get homeHeroDefaultSubtitle =>
      'Play from your library and your current track will live here.';

  @override
  String get homeHeroOpenPlayer => 'Open Player';

  @override
  String get homeHeroResume => 'Resume';

  @override
  String get homeRecentPlaysTitle => 'Recent Plays';

  @override
  String get homeRecentPlaysEmpty => 'No recent local plays';

  @override
  String get homeRecentPlaysEmptySubtitle =>
      'Play something from your library and it will show up here.';

  @override
  String get homeFavoriteTracksTitle => 'Favorite Tracks';

  @override
  String get homeFavoriteTracksEmpty => 'No favorites yet';

  @override
  String get homeFavoriteTracksEmptySubtitle =>
      'Tap the heart on Now Playing to keep your top tracks here.';

  @override
  String get homeRecentSearchesTitle => 'Recent Online Searches';

  @override
  String get homeRecentSearchesEmpty => 'No online searches yet';

  @override
  String get homeRecentSearchesEmptySubtitle =>
      'Run a search in Online Discovery and it will show up here.';

  @override
  String get homeSearchDemoMode => 'Demo mode';

  @override
  String get homeSearchSafeMode => 'Safe mode';

  @override
  String homeSearchResultCount(int count) {
    return '$count results';
  }

  @override
  String get homeDailyMixesTitle => 'Daily Mixes';

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homePlayMore => 'Play more';

  @override
  String get homeNewReleasesTitle => 'New Releases';

  @override
  String get homeAlbumOfWeek => 'Album of the Week';

  @override
  String get homeExploreAlbum => 'Explore Album';

  @override
  String get nowPlayingNothingPlaying => 'Nothing is playing yet.';

  @override
  String get nowPlayingFromDevice => 'PLAYING FROM DEVICE';

  @override
  String get nowPlayingCollapsePlayer => 'Collapse player';

  @override
  String get nowPlayingTrackActionsTooltip => 'Track actions';

  @override
  String get nowPlayingAddToFavorites => 'Add to favorites';

  @override
  String get nowPlayingRemoveFromFavorites => 'Remove from favorites';

  @override
  String get nowPlayingPause => 'Pause playback';

  @override
  String get nowPlayingResumeSemantic => 'Resume playback';

  @override
  String get nowPlayingSeekLabel => 'Playback position';

  @override
  String get nowPlayingVolumeLabel => 'Volume';

  @override
  String get nowPlayingSpeedLabel => 'Speed';

  @override
  String get nowPlayingEqLabel => 'EQ';

  @override
  String get nowPlayingShareLabel => 'Share';

  @override
  String get nowPlayingDevicesLabel => 'Devices';

  @override
  String get nowPlayingQueueLabel => 'Queue';

  @override
  String get nowPlayingCopyTrackInfo => 'Copy track info';

  @override
  String get nowPlayingCopyQueueLabel => 'Copy full queue as track list';

  @override
  String nowPlayingQueueCount(int count) {
    return '$count tracks in current queue';
  }

  @override
  String get nowPlayingCopiedToClipboard => 'Track info copied to clipboard';

  @override
  String get nowPlayingQueueCopied => 'Queue copied to clipboard';

  @override
  String get nowPlayingThisDevice => 'This device';

  @override
  String get nowPlayingThisDeviceSubtitle =>
      'Current playback stays on the active phone output.';

  @override
  String get nowPlayingBluetooth => 'Bluetooth or cast route';

  @override
  String get nowPlayingBluetoothSubtitle =>
      'Use your system media output picker to move playback. Stitch Music follows the system route.';

  @override
  String get nowPlayingVolumeSheetTitle => 'Playback volume';

  @override
  String get nowPlayingVolumeSheetSubtitle =>
      'Adjust just_audio output volume for the current session.';

  @override
  String get nowPlayingSpeedSheetTitle => 'Playback speed';

  @override
  String get nowPlayingSpeedSheetSubtitle =>
      'Slow down for detail or speed up for review.';

  @override
  String get nowPlayingRemoveFavorite => 'Remove favorite';

  @override
  String get nowPlayingAddFavorite => 'Add favorite';

  @override
  String get nowPlayingFavoriteSubtitle =>
      'Pin this track in your Favorites section.';

  @override
  String get nowPlayingAddToPlaylist => 'Add to playlist';

  @override
  String get nowPlayingAddToPlaylistSubtitle =>
      'Save the current track to one of your playlists.';

  @override
  String get nowPlayingShareTrack => 'Share track';

  @override
  String get nowPlayingShareTrackSubtitle =>
      'Copy track details or the active queue.';

  @override
  String get nowPlayingOpenInsights => 'Open insights';

  @override
  String get nowPlayingOpenInsightsSubtitle =>
      'Review current analytics and listening stats.';

  @override
  String get nowPlayingOpenSettings => 'Open settings';

  @override
  String get nowPlayingOpenSettingsSubtitle =>
      'Jump to EQ and app control settings.';

  @override
  String get nowPlayingNoPlaylistsCreate =>
      'No playlists yet. Create one from the Playlists tab.';

  @override
  String nowPlayingAddedToPlaylist(String name) {
    return 'Added to \"$name\"';
  }

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsListeningHabits => 'LISTENING HABITS';

  @override
  String get insightsTopTracks => 'TOP TRACKS';

  @override
  String get insightsTopArtists => 'TOP ARTISTS';

  @override
  String get insightsTotalPlays => 'Total Plays';

  @override
  String get insightsListened => 'Listened';

  @override
  String get insightsInLibrary => 'In Library';

  @override
  String get insightsFavorites => 'Favorites';

  @override
  String get insightsSkipRate => 'Skip Rate';

  @override
  String get insightsSkipRateNoData => 'No data yet';

  @override
  String get insightsSkipRateLow => 'Low — you finish what you start 🎯';

  @override
  String get insightsSkipRateModerate => 'Moderate — fairly selective';

  @override
  String get insightsSkipRateHigh => 'High — skipping a lot';

  @override
  String get insightsLast7Days => 'Last 7 Days';

  @override
  String get insightsDayMon => 'Mon';

  @override
  String get insightsDayTue => 'Tue';

  @override
  String get insightsDayWed => 'Wed';

  @override
  String get insightsDayThu => 'Thu';

  @override
  String get insightsDayFri => 'Fri';

  @override
  String get insightsDaySat => 'Sat';

  @override
  String get insightsDaySun => 'Sun';

  @override
  String get insightsNoTopTracks => 'Play some tracks to see your Top Tracks';

  @override
  String get insightsNoTopArtists => 'Coming soon — play more tracks';

  @override
  String insightsMinPlayed(int count) {
    return '$count min played';
  }

  @override
  String get insightsPlaySingular => 'play';

  @override
  String get insightsPlayPlural => 'plays';

  @override
  String get insightsClearStats => 'Clear All Stats';

  @override
  String get insightsClearTitle => 'Clear all stats?';

  @override
  String get insightsClearContent =>
      'This removes all play history and analytics data. Your library, playlists, and favorites are not affected.';

  @override
  String get insightsCancelButton => 'Cancel';

  @override
  String get insightsClearButton => 'Clear';

  @override
  String get playlistsTitle => 'Playlists';

  @override
  String get playlistsSaveQueue => 'Save Queue';

  @override
  String playlistsTrackCount(int count) {
    return '$count tracks';
  }

  @override
  String get playlistsRenameTooltip => 'Rename';

  @override
  String get playlistsDeleteTooltip => 'Delete playlist';

  @override
  String get playlistsPlayButton => 'Play';

  @override
  String get playlistsEmptyTitle => 'No playlists yet';

  @override
  String get playlistsEmptySubtitle =>
      'Play songs from your library, then save your current queue as a playlist.';

  @override
  String get playlistsCreateFromQueue => 'Create from Queue';

  @override
  String get playlistsCreateTitle => 'Create Playlist';

  @override
  String get playlistsNameHint => 'Playlist name';

  @override
  String get playlistsCancelButton => 'Cancel';

  @override
  String get playlistsSaveButton => 'Save';

  @override
  String get playlistsQueueEmpty => 'Queue is empty. Play something first.';

  @override
  String playlistsSaved(String name) {
    return 'Saved \"$name\"';
  }

  @override
  String playlistsDefaultName(String time) {
    return 'My Playlist $time';
  }

  @override
  String get playlistsRenameTitle => 'Rename Playlist';

  @override
  String get onlineSearchTitle => 'Online Search (YouTube)';

  @override
  String get onlineSearchDiscoveryNote =>
      'Discovery only. Playback stays blocked until official API auth and entitlement are available.';

  @override
  String get onlineSearchProviderUnavailable =>
      'Provider setup is unavailable.';

  @override
  String get onlineSearchEntitlementRequired =>
      'Entitlement is required for this track.';

  @override
  String get onlineSearchUriUnavailable =>
      'Playback URI unavailable. Backend remains fail-closed.';

  @override
  String onlineSearchPlayingNow(String title) {
    return 'Playing \"$title\" now.';
  }

  @override
  String onlineSearchAddedToQueue(String title) {
    return 'Added \"$title\" to queue.';
  }

  @override
  String get onlineSearchRefreshEntitlement => 'Refresh entitlement';

  @override
  String get onlineSearchDemoModeLabel =>
      'Demo mode: mocked provider results for UI testing';

  @override
  String get onlineSearchProductionModeLabel =>
      'Production-safe mode: fail-closed until official backend is configured';

  @override
  String get onlineSearchHint => 'Search artists, songs, channels...';

  @override
  String get onlineSearchButton => 'Search';

  @override
  String get onlineSearchEntitlementUnknown => 'Entitlement unknown';

  @override
  String get onlineSearchEntitlementUnknownBody =>
      'Could not determine provider entitlement state.';

  @override
  String get onlineSearchSignInRequired => 'Sign in required';

  @override
  String get onlineSearchSignInRequiredBody =>
      'Please sign in with the official provider flow.';

  @override
  String get onlineSearchPremiumRequired => 'Premium required';

  @override
  String get onlineSearchPremiumRequiredBody =>
      'Current account level does not allow in-app playback.';

  @override
  String get onlineSearchUnavailableInRegion => 'Unavailable in region';

  @override
  String get onlineSearchUnavailableInRegionBody =>
      'Streaming is restricted for your region.';

  @override
  String get onlineSearchEntitled => 'Entitled';

  @override
  String get onlineSearchEntitledBody =>
      'Account appears eligible for provider playback checks.';

  @override
  String get onlineSearchNoCatalog =>
      'Search online catalog to discover tracks.';

  @override
  String get onlineSearchNoResults => 'No results found.';

  @override
  String get onlineSearchLockedBadge => 'Locked';

  @override
  String get onlineSearchOpenBadge => 'Open';

  @override
  String get onlineSearchAddButton => 'Add';

  @override
  String get onlineSearchPlayButton => 'Play';
}
