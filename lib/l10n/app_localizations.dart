import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Stitch Music'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Music Lover'**
  String get profileDisplayName;

  /// No description provided for @profileSongs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get profileSongs;

  /// No description provided for @profileArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get profileArtists;

  /// No description provided for @profileHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get profileHours;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// No description provided for @profileHistory.
  ///
  /// In en, this message translates to:
  /// **'Listening History'**
  String get profileHistory;

  /// No description provided for @profileDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get profileDownloads;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Library'**
  String get libraryTitle;

  /// No description provided for @libraryRescanTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rescan device'**
  String get libraryRescanTooltip;

  /// No description provided for @libraryOnlineSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Online search (YouTube)'**
  String get libraryOnlineSearchTooltip;

  /// No description provided for @libraryOnlineSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Online Search'**
  String get libraryOnlineSearchTitle;

  /// No description provided for @libraryOnlineSearchDescription.
  ///
  /// In en, this message translates to:
  /// **'Search YouTube discovery results in demo or safe mode.'**
  String get libraryOnlineSearchDescription;

  /// No description provided for @openLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// No description provided for @librarySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search songs, artists, albums...'**
  String get librarySearchHint;

  /// No description provided for @libraryFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryFilterAll;

  /// No description provided for @libraryFilterSongs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get libraryFilterSongs;

  /// No description provided for @libraryFilterAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get libraryFilterAlbums;

  /// No description provided for @libraryFilterArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get libraryFilterArtists;

  /// No description provided for @songsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} songs'**
  String songsCount(int count);

  /// No description provided for @songsDetectedCount.
  ///
  /// In en, this message translates to:
  /// **'Songs detected: {count}'**
  String songsDetectedCount(int count);

  /// No description provided for @mediaAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Media access granted'**
  String get mediaAccessGranted;

  /// No description provided for @permissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission permanently denied'**
  String get permissionPermanentlyDenied;

  /// No description provided for @mediaPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Media permission required'**
  String get mediaPermissionRequired;

  /// No description provided for @scanningStatus.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanningStatus;

  /// No description provided for @idleStatus.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idleStatus;

  /// No description provided for @lastScan.
  ///
  /// In en, this message translates to:
  /// **'Last scan: {value}'**
  String lastScan(String value);

  /// No description provided for @neverLabel.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get neverLabel;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @grantMusicPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant music permission'**
  String get grantMusicPermission;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsAccessibilitySection.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibilitySection;

  /// No description provided for @settingsHighContrastTitle.
  ///
  /// In en, this message translates to:
  /// **'High contrast mode'**
  String get settingsHighContrastTitle;

  /// No description provided for @settingsHighContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for text and key surfaces'**
  String get settingsHighContrastSubtitle;

  /// No description provided for @settingsTextScaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsTextScaleTitle;

  /// No description provided for @settingsTextScaleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scale text across the app'**
  String get settingsTextScaleSubtitle;

  /// No description provided for @settingsTextScaleReset.
  ///
  /// In en, this message translates to:
  /// **'Reset text size'**
  String get settingsTextScaleReset;

  /// No description provided for @settingsAccessibilityRoadmapTitle.
  ///
  /// In en, this message translates to:
  /// **'More accessibility controls'**
  String get settingsAccessibilityRoadmapTitle;

  /// No description provided for @settingsAccessibilityRoadmapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Screen reader semantics, focus tuning, and text scaling refinements are in progress'**
  String get settingsAccessibilityRoadmapSubtitle;

  /// No description provided for @settingsGeneralSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralSection;

  /// No description provided for @settingsOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline and cache'**
  String get settingsOfflineTitle;

  /// No description provided for @settingsOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage pins, cache limits, and offline behavior'**
  String get settingsOfflineSubtitle;

  /// No description provided for @settingsAudioSection.
  ///
  /// In en, this message translates to:
  /// **'Audio effects'**
  String get settingsAudioSection;

  /// No description provided for @settingsEqTitle.
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get settingsEqTitle;

  /// No description provided for @settingsEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get settingsEnabledLabel;

  /// No description provided for @settingsDisabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsDisabledLabel;

  /// No description provided for @settingsPresetLabel.
  ///
  /// In en, this message translates to:
  /// **'Preset'**
  String get settingsPresetLabel;

  /// No description provided for @settingsCustomEqLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom EQ'**
  String get settingsCustomEqLabel;

  /// No description provided for @settingsResetEq.
  ///
  /// In en, this message translates to:
  /// **'Reset to Flat'**
  String get settingsResetEq;

  /// No description provided for @homeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'The Sonic Gallery'**
  String get homeAppBarTitle;

  /// No description provided for @homeOpenQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Open quick actions'**
  String get homeOpenQuickActions;

  /// No description provided for @homeQaSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeQaSettings;

  /// No description provided for @homeQaSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Audio, localization, and app controls'**
  String get homeQaSettingsSubtitle;

  /// No description provided for @homeQaCacheOffline.
  ///
  /// In en, this message translates to:
  /// **'Cache & Offline'**
  String get homeQaCacheOffline;

  /// No description provided for @homeQaCacheOfflineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pinned tracks, offline mode, and cache size'**
  String get homeQaCacheOfflineSubtitle;

  /// No description provided for @homeQaInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get homeQaInsights;

  /// No description provided for @homeQaInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Playback stats and recent listening trends'**
  String get homeQaInsightsSubtitle;

  /// No description provided for @homeQaProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeQaProfile;

  /// No description provided for @homeQaProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the profile hub and account actions'**
  String get homeQaProfileSubtitle;

  /// No description provided for @homeOnlineDiscoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Online Discovery'**
  String get homeOnlineDiscoveryTitle;

  /// No description provided for @homeOnlineDiscoveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore the YouTube search experience in demo mode while official API integration stays fail-closed.'**
  String get homeOnlineDiscoveryDescription;

  /// No description provided for @homeOnlineDiscoveryChipDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo Results'**
  String get homeOnlineDiscoveryChipDemo;

  /// No description provided for @homeOnlineDiscoveryChipEntitlement.
  ///
  /// In en, this message translates to:
  /// **'Entitlement Banners'**
  String get homeOnlineDiscoveryChipEntitlement;

  /// No description provided for @homeOnlineDiscoveryChipPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy-Compliant'**
  String get homeOnlineDiscoveryChipPolicy;

  /// No description provided for @homeOpenOnlineSearch.
  ///
  /// In en, this message translates to:
  /// **'Open Online Search'**
  String get homeOpenOnlineSearch;

  /// No description provided for @homeNoPlaybackYet.
  ///
  /// In en, this message translates to:
  /// **'No playback is enabled here yet.'**
  String get homeNoPlaybackYet;

  /// No description provided for @homeHeroReadyToPlay.
  ///
  /// In en, this message translates to:
  /// **'READY TO PLAY'**
  String get homeHeroReadyToPlay;

  /// No description provided for @homeHeroNowPlayingBadge.
  ///
  /// In en, this message translates to:
  /// **'NOW PLAYING'**
  String get homeHeroNowPlayingBadge;

  /// No description provided for @homeHeroDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Your Session'**
  String get homeHeroDefaultTitle;

  /// No description provided for @homeHeroDefaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play from your library and your current track will live here.'**
  String get homeHeroDefaultSubtitle;

  /// No description provided for @homeHeroOpenPlayer.
  ///
  /// In en, this message translates to:
  /// **'Open Player'**
  String get homeHeroOpenPlayer;

  /// No description provided for @homeHeroResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get homeHeroResume;

  /// No description provided for @homeRecentPlaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Plays'**
  String get homeRecentPlaysTitle;

  /// No description provided for @homeRecentPlaysEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recent local plays'**
  String get homeRecentPlaysEmpty;

  /// No description provided for @homeRecentPlaysEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play something from your library and it will show up here.'**
  String get homeRecentPlaysEmptySubtitle;

  /// No description provided for @homeFavoriteTracksTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorite Tracks'**
  String get homeFavoriteTracksTitle;

  /// No description provided for @homeFavoriteTracksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get homeFavoriteTracksEmpty;

  /// No description provided for @homeFavoriteTracksEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on Now Playing to keep your top tracks here.'**
  String get homeFavoriteTracksEmptySubtitle;

  /// No description provided for @homeRecentSearchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Online Searches'**
  String get homeRecentSearchesTitle;

  /// No description provided for @homeRecentSearchesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No online searches yet'**
  String get homeRecentSearchesEmpty;

  /// No description provided for @homeRecentSearchesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Run a search in Online Discovery and it will show up here.'**
  String get homeRecentSearchesEmptySubtitle;

  /// No description provided for @homeSearchDemoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get homeSearchDemoMode;

  /// No description provided for @homeSearchSafeMode.
  ///
  /// In en, this message translates to:
  /// **'Safe mode'**
  String get homeSearchSafeMode;

  /// No description provided for @homeSearchResultCount.
  ///
  /// In en, this message translates to:
  /// **'{count} results'**
  String homeSearchResultCount(int count);

  /// No description provided for @homeDailyMixesTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Mixes'**
  String get homeDailyMixesTitle;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// No description provided for @homeNewReleasesTitle.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get homeNewReleasesTitle;

  /// No description provided for @homeAlbumOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Album of the Week'**
  String get homeAlbumOfWeek;

  /// No description provided for @homeExploreAlbum.
  ///
  /// In en, this message translates to:
  /// **'Explore Album'**
  String get homeExploreAlbum;

  /// No description provided for @nowPlayingNothingPlaying.
  ///
  /// In en, this message translates to:
  /// **'Nothing is playing yet.'**
  String get nowPlayingNothingPlaying;

  /// No description provided for @nowPlayingFromDevice.
  ///
  /// In en, this message translates to:
  /// **'PLAYING FROM DEVICE'**
  String get nowPlayingFromDevice;

  /// No description provided for @nowPlayingCollapsePlayer.
  ///
  /// In en, this message translates to:
  /// **'Collapse player'**
  String get nowPlayingCollapsePlayer;

  /// No description provided for @nowPlayingTrackActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Track actions'**
  String get nowPlayingTrackActionsTooltip;

  /// No description provided for @nowPlayingAddToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get nowPlayingAddToFavorites;

  /// No description provided for @nowPlayingRemoveFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get nowPlayingRemoveFromFavorites;

  /// No description provided for @nowPlayingPause.
  ///
  /// In en, this message translates to:
  /// **'Pause playback'**
  String get nowPlayingPause;

  /// No description provided for @nowPlayingResumeSemantic.
  ///
  /// In en, this message translates to:
  /// **'Resume playback'**
  String get nowPlayingResumeSemantic;

  /// No description provided for @nowPlayingVolumeLabel.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get nowPlayingVolumeLabel;

  /// No description provided for @nowPlayingSpeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get nowPlayingSpeedLabel;

  /// No description provided for @nowPlayingEqLabel.
  ///
  /// In en, this message translates to:
  /// **'EQ'**
  String get nowPlayingEqLabel;

  /// No description provided for @nowPlayingShareLabel.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get nowPlayingShareLabel;

  /// No description provided for @nowPlayingDevicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get nowPlayingDevicesLabel;

  /// No description provided for @nowPlayingQueueLabel.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get nowPlayingQueueLabel;

  /// No description provided for @nowPlayingCopyTrackInfo.
  ///
  /// In en, this message translates to:
  /// **'Copy track info'**
  String get nowPlayingCopyTrackInfo;

  /// No description provided for @nowPlayingCopyQueueLabel.
  ///
  /// In en, this message translates to:
  /// **'Copy full queue as track list'**
  String get nowPlayingCopyQueueLabel;

  /// No description provided for @nowPlayingQueueCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks in current queue'**
  String nowPlayingQueueCount(int count);

  /// No description provided for @nowPlayingCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Track info copied to clipboard'**
  String get nowPlayingCopiedToClipboard;

  /// No description provided for @nowPlayingQueueCopied.
  ///
  /// In en, this message translates to:
  /// **'Queue copied to clipboard'**
  String get nowPlayingQueueCopied;

  /// No description provided for @nowPlayingThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get nowPlayingThisDevice;

  /// No description provided for @nowPlayingThisDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current playback stays on the active phone output.'**
  String get nowPlayingThisDeviceSubtitle;

  /// No description provided for @nowPlayingBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth or cast route'**
  String get nowPlayingBluetooth;

  /// No description provided for @nowPlayingBluetoothSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your system media output picker to move playback. Stitch Music follows the system route.'**
  String get nowPlayingBluetoothSubtitle;

  /// No description provided for @nowPlayingVolumeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Playback volume'**
  String get nowPlayingVolumeSheetTitle;

  /// No description provided for @nowPlayingVolumeSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust just_audio output volume for the current session.'**
  String get nowPlayingVolumeSheetSubtitle;

  /// No description provided for @nowPlayingSpeedSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get nowPlayingSpeedSheetTitle;

  /// No description provided for @nowPlayingSpeedSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Slow down for detail or speed up for review.'**
  String get nowPlayingSpeedSheetSubtitle;

  /// No description provided for @nowPlayingRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get nowPlayingRemoveFavorite;

  /// No description provided for @nowPlayingAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add favorite'**
  String get nowPlayingAddFavorite;

  /// No description provided for @nowPlayingFavoriteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pin this track in your Favorites section.'**
  String get nowPlayingFavoriteSubtitle;

  /// No description provided for @nowPlayingAddToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get nowPlayingAddToPlaylist;

  /// No description provided for @nowPlayingAddToPlaylistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save the current track to one of your playlists.'**
  String get nowPlayingAddToPlaylistSubtitle;

  /// No description provided for @nowPlayingShareTrack.
  ///
  /// In en, this message translates to:
  /// **'Share track'**
  String get nowPlayingShareTrack;

  /// No description provided for @nowPlayingShareTrackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy track details or the active queue.'**
  String get nowPlayingShareTrackSubtitle;

  /// No description provided for @nowPlayingOpenInsights.
  ///
  /// In en, this message translates to:
  /// **'Open insights'**
  String get nowPlayingOpenInsights;

  /// No description provided for @nowPlayingOpenInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review current analytics and listening stats.'**
  String get nowPlayingOpenInsightsSubtitle;

  /// No description provided for @nowPlayingOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get nowPlayingOpenSettings;

  /// No description provided for @nowPlayingOpenSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jump to EQ and app control settings.'**
  String get nowPlayingOpenSettingsSubtitle;

  /// No description provided for @nowPlayingNoPlaylistsCreate.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet. Create one from the Playlists tab.'**
  String get nowPlayingNoPlaylistsCreate;

  /// No description provided for @nowPlayingAddedToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Added to \"{name}\"'**
  String nowPlayingAddedToPlaylist(String name);

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsListeningHabits.
  ///
  /// In en, this message translates to:
  /// **'LISTENING HABITS'**
  String get insightsListeningHabits;

  /// No description provided for @insightsTopTracks.
  ///
  /// In en, this message translates to:
  /// **'TOP TRACKS'**
  String get insightsTopTracks;

  /// No description provided for @insightsTopArtists.
  ///
  /// In en, this message translates to:
  /// **'TOP ARTISTS'**
  String get insightsTopArtists;

  /// No description provided for @insightsTotalPlays.
  ///
  /// In en, this message translates to:
  /// **'Total Plays'**
  String get insightsTotalPlays;

  /// No description provided for @insightsListened.
  ///
  /// In en, this message translates to:
  /// **'Listened'**
  String get insightsListened;

  /// No description provided for @insightsInLibrary.
  ///
  /// In en, this message translates to:
  /// **'In Library'**
  String get insightsInLibrary;

  /// No description provided for @insightsFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get insightsFavorites;

  /// No description provided for @insightsSkipRate.
  ///
  /// In en, this message translates to:
  /// **'Skip Rate'**
  String get insightsSkipRate;

  /// No description provided for @insightsSkipRateNoData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get insightsSkipRateNoData;

  /// No description provided for @insightsSkipRateLow.
  ///
  /// In en, this message translates to:
  /// **'Low — you finish what you start 🎯'**
  String get insightsSkipRateLow;

  /// No description provided for @insightsSkipRateModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate — fairly selective'**
  String get insightsSkipRateModerate;

  /// No description provided for @insightsSkipRateHigh.
  ///
  /// In en, this message translates to:
  /// **'High — skipping a lot'**
  String get insightsSkipRateHigh;

  /// No description provided for @insightsLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get insightsLast7Days;

  /// No description provided for @insightsDayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get insightsDayMon;

  /// No description provided for @insightsDayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get insightsDayTue;

  /// No description provided for @insightsDayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get insightsDayWed;

  /// No description provided for @insightsDayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get insightsDayThu;

  /// No description provided for @insightsDayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get insightsDayFri;

  /// No description provided for @insightsDaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get insightsDaySat;

  /// No description provided for @insightsDaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get insightsDaySun;

  /// No description provided for @insightsNoTopTracks.
  ///
  /// In en, this message translates to:
  /// **'Play some tracks to see your Top Tracks'**
  String get insightsNoTopTracks;

  /// No description provided for @insightsNoTopArtists.
  ///
  /// In en, this message translates to:
  /// **'Coming soon — play more tracks'**
  String get insightsNoTopArtists;

  /// No description provided for @insightsMinPlayed.
  ///
  /// In en, this message translates to:
  /// **'{count} min played'**
  String insightsMinPlayed(int count);

  /// No description provided for @insightsPlaySingular.
  ///
  /// In en, this message translates to:
  /// **'play'**
  String get insightsPlaySingular;

  /// No description provided for @insightsPlayPlural.
  ///
  /// In en, this message translates to:
  /// **'plays'**
  String get insightsPlayPlural;

  /// No description provided for @insightsClearStats.
  ///
  /// In en, this message translates to:
  /// **'Clear All Stats'**
  String get insightsClearStats;

  /// No description provided for @insightsClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all stats?'**
  String get insightsClearTitle;

  /// No description provided for @insightsClearContent.
  ///
  /// In en, this message translates to:
  /// **'This removes all play history and analytics data. Your library, playlists, and favorites are not affected.'**
  String get insightsClearContent;

  /// No description provided for @insightsCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get insightsCancelButton;

  /// No description provided for @insightsClearButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get insightsClearButton;

  /// No description provided for @playlistsTitle.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlistsTitle;

  /// No description provided for @playlistsSaveQueue.
  ///
  /// In en, this message translates to:
  /// **'Save Queue'**
  String get playlistsSaveQueue;

  /// No description provided for @playlistsTrackCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks'**
  String playlistsTrackCount(int count);

  /// No description provided for @playlistsRenameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get playlistsRenameTooltip;

  /// No description provided for @playlistsDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist'**
  String get playlistsDeleteTooltip;

  /// No description provided for @playlistsPlayButton.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playlistsPlayButton;

  /// No description provided for @playlistsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No playlists yet'**
  String get playlistsEmptyTitle;

  /// No description provided for @playlistsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play songs from your library, then save your current queue as a playlist.'**
  String get playlistsEmptySubtitle;

  /// No description provided for @playlistsCreateFromQueue.
  ///
  /// In en, this message translates to:
  /// **'Create from Queue'**
  String get playlistsCreateFromQueue;

  /// No description provided for @playlistsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get playlistsCreateTitle;

  /// No description provided for @playlistsNameHint.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistsNameHint;

  /// No description provided for @playlistsCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get playlistsCancelButton;

  /// No description provided for @playlistsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get playlistsSaveButton;

  /// No description provided for @playlistsQueueEmpty.
  ///
  /// In en, this message translates to:
  /// **'Queue is empty. Play something first.'**
  String get playlistsQueueEmpty;

  /// No description provided for @playlistsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved \"{name}\"'**
  String playlistsSaved(String name);

  /// No description provided for @playlistsRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename Playlist'**
  String get playlistsRenameTitle;

  /// No description provided for @onlineSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Online Search (YouTube)'**
  String get onlineSearchTitle;

  /// No description provided for @onlineSearchDiscoveryNote.
  ///
  /// In en, this message translates to:
  /// **'Discovery only. Playback stays blocked until official API auth and entitlement are available.'**
  String get onlineSearchDiscoveryNote;

  /// No description provided for @onlineSearchProviderUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Provider setup is unavailable.'**
  String get onlineSearchProviderUnavailable;

  /// No description provided for @onlineSearchEntitlementRequired.
  ///
  /// In en, this message translates to:
  /// **'Entitlement is required for this track.'**
  String get onlineSearchEntitlementRequired;

  /// No description provided for @onlineSearchUriUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Playback URI unavailable. Backend remains fail-closed.'**
  String get onlineSearchUriUnavailable;

  /// No description provided for @onlineSearchPlayingNow.
  ///
  /// In en, this message translates to:
  /// **'Playing \"{title}\" now.'**
  String onlineSearchPlayingNow(String title);

  /// No description provided for @onlineSearchAddedToQueue.
  ///
  /// In en, this message translates to:
  /// **'Added \"{title}\" to queue.'**
  String onlineSearchAddedToQueue(String title);

  /// No description provided for @onlineSearchRefreshEntitlement.
  ///
  /// In en, this message translates to:
  /// **'Refresh entitlement'**
  String get onlineSearchRefreshEntitlement;

  /// No description provided for @onlineSearchDemoModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: mocked provider results for UI testing'**
  String get onlineSearchDemoModeLabel;

  /// No description provided for @onlineSearchProductionModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Production-safe mode: fail-closed until official backend is configured'**
  String get onlineSearchProductionModeLabel;

  /// No description provided for @onlineSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search artists, songs, channels...'**
  String get onlineSearchHint;

  /// No description provided for @onlineSearchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get onlineSearchButton;

  /// No description provided for @onlineSearchEntitlementUnknown.
  ///
  /// In en, this message translates to:
  /// **'Entitlement unknown'**
  String get onlineSearchEntitlementUnknown;

  /// No description provided for @onlineSearchEntitlementUnknownBody.
  ///
  /// In en, this message translates to:
  /// **'Could not determine provider entitlement state.'**
  String get onlineSearchEntitlementUnknownBody;

  /// No description provided for @onlineSearchSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get onlineSearchSignInRequired;

  /// No description provided for @onlineSearchSignInRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Please sign in with the official provider flow.'**
  String get onlineSearchSignInRequiredBody;

  /// No description provided for @onlineSearchPremiumRequired.
  ///
  /// In en, this message translates to:
  /// **'Premium required'**
  String get onlineSearchPremiumRequired;

  /// No description provided for @onlineSearchPremiumRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Current account level does not allow in-app playback.'**
  String get onlineSearchPremiumRequiredBody;

  /// No description provided for @onlineSearchUnavailableInRegion.
  ///
  /// In en, this message translates to:
  /// **'Unavailable in region'**
  String get onlineSearchUnavailableInRegion;

  /// No description provided for @onlineSearchUnavailableInRegionBody.
  ///
  /// In en, this message translates to:
  /// **'Streaming is restricted for your region.'**
  String get onlineSearchUnavailableInRegionBody;

  /// No description provided for @onlineSearchEntitled.
  ///
  /// In en, this message translates to:
  /// **'Entitled'**
  String get onlineSearchEntitled;

  /// No description provided for @onlineSearchEntitledBody.
  ///
  /// In en, this message translates to:
  /// **'Account appears eligible for provider playback checks.'**
  String get onlineSearchEntitledBody;

  /// No description provided for @onlineSearchNoCatalog.
  ///
  /// In en, this message translates to:
  /// **'Search online catalog to discover tracks.'**
  String get onlineSearchNoCatalog;

  /// No description provided for @onlineSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get onlineSearchNoResults;

  /// No description provided for @onlineSearchLockedBadge.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get onlineSearchLockedBadge;

  /// No description provided for @onlineSearchOpenBadge.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get onlineSearchOpenBadge;

  /// No description provided for @onlineSearchAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get onlineSearchAddButton;

  /// No description provided for @onlineSearchPlayButton.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get onlineSearchPlayButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
