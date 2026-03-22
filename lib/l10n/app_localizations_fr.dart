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

  @override
  String get settingsLanguageSection => 'Langue';

  @override
  String get settingsLanguageLabel => 'Langue de l\'application';

  @override
  String get settingsLanguageSystem => 'Par defaut du systeme';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsLanguageSpanish => 'Espagnol';

  @override
  String get settingsLanguageFrench => 'Francais';

  @override
  String get settingsLanguageGerman => 'Allemand';

  @override
  String get settingsAccessibilitySection => 'Accessibilite';

  @override
  String get settingsHighContrastTitle => 'Mode contraste eleve';

  @override
  String get settingsHighContrastSubtitle =>
      'Augmente le contraste du texte et des surfaces principales';

  @override
  String get settingsTextScaleTitle => 'Taille du texte';

  @override
  String get settingsTextScaleSubtitle =>
      'Ajuste le texte dans toute l\'application';

  @override
  String get settingsTextScaleReset => 'Reinitialiser la taille du texte';

  @override
  String get settingsAccessibilityRoadmapTitle =>
      'Plus de controles d\'accessibilite';

  @override
  String get settingsAccessibilityRoadmapSubtitle =>
      'Semantique lecteur d\'ecran, ajustements du focus et ameliorations de l\'echelle du texte en cours';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsOfflineTitle => 'Hors ligne et cache';

  @override
  String get settingsOfflineSubtitle =>
      'Gerer les epingles, limites de cache et comportement hors ligne';

  @override
  String get settingsAudioSection => 'Effets audio';

  @override
  String get settingsEqTitle => 'Egaliseur';

  @override
  String get settingsEnabledLabel => 'Actif';

  @override
  String get settingsDisabledLabel => 'Desactive';

  @override
  String get settingsPresetLabel => 'Preset';

  @override
  String get settingsCustomEqLabel => 'EQ personnalise';

  @override
  String get settingsResetEq => 'Reinitialiser a plat';

  @override
  String get homeAppBarTitle => 'The Sonic Gallery';

  @override
  String get homeOpenQuickActions => 'Ouvrir les actions rapides';

  @override
  String get homeQaSettings => 'Parametres';

  @override
  String get homeQaSettingsSubtitle =>
      'Audio, localisation et controles de l\'application';

  @override
  String get homeQaCacheOffline => 'Cache et hors ligne';

  @override
  String get homeQaCacheOfflineSubtitle =>
      'Titres epingles, mode hors ligne et taille du cache';

  @override
  String get homeQaInsights => 'Statistiques';

  @override
  String get homeQaInsightsSubtitle =>
      'Stats de lecture et tendances d\'ecoute';

  @override
  String get homeQaProfile => 'Profil';

  @override
  String get homeQaProfileSubtitle =>
      'Ouvrir le hub de profil et les actions du compte';

  @override
  String get homeOnlineDiscoveryTitle => 'Decouverte en ligne';

  @override
  String get homeOnlineDiscoveryDescription =>
      'Explorez la recherche YouTube en mode demo pendant que l\'integration officielle de l\'API reste fermee.';

  @override
  String get homeOnlineDiscoveryChipDemo => 'Resultats demo';

  @override
  String get homeOnlineDiscoveryChipEntitlement => 'Bannieres de droits';

  @override
  String get homeOnlineDiscoveryChipPolicy => 'Conforme a la politique';

  @override
  String get homeOpenOnlineSearch => 'Ouvrir la recherche en ligne';

  @override
  String get homeNoPlaybackYet =>
      'Aucune lecture disponible ici pour l\'instant.';

  @override
  String get homeHeroReadyToPlay => 'PRET A LIRE';

  @override
  String get homeHeroNowPlayingBadge => 'EN LECTURE';

  @override
  String get homeHeroDefaultTitle => 'Commencez votre session';

  @override
  String get homeHeroDefaultSubtitle =>
      'Lisez un titre de votre bibliotheque et il apparaitra ici.';

  @override
  String get homeHeroOpenPlayer => 'Ouvrir le lecteur';

  @override
  String get homeHeroResume => 'Reprendre';

  @override
  String get homeRecentPlaysTitle => 'Lectures recentes';

  @override
  String get homeRecentPlaysEmpty => 'Aucune lecture locale recente';

  @override
  String get homeRecentPlaysEmptySubtitle =>
      'Lisez un titre de votre bibliotheque et il apparaitra ici.';

  @override
  String get homeFavoriteTracksTitle => 'Titres favoris';

  @override
  String get homeFavoriteTracksEmpty => 'Aucun favori pour l\'instant';

  @override
  String get homeFavoriteTracksEmptySubtitle =>
      'Appuyez sur le coeur dans En lecture pour conserver vos meilleurs titres.';

  @override
  String get homeRecentSearchesTitle => 'Recherches en ligne recentes';

  @override
  String get homeRecentSearchesEmpty =>
      'Aucune recherche en ligne pour l\'instant';

  @override
  String get homeRecentSearchesEmptySubtitle =>
      'Effectuez une recherche dans Decouverte et elle apparaitra ici.';

  @override
  String get homeSearchDemoMode => 'Mode demo';

  @override
  String get homeSearchSafeMode => 'Mode securise';

  @override
  String homeSearchResultCount(int count) {
    return '$count resultats';
  }

  @override
  String get homeDailyMixesTitle => 'Mix du jour';

  @override
  String get homeSeeAll => 'Tout voir';

  @override
  String get homePlayMore => 'Ecouter plus';

  @override
  String get homeNewReleasesTitle => 'Nouvelles sorties';

  @override
  String get homeAlbumOfWeek => 'Album de la semaine';

  @override
  String get homeExploreAlbum => 'Explorer l\'album';

  @override
  String get nowPlayingNothingPlaying => 'Rien ne joue pour l\'instant.';

  @override
  String get nowPlayingFromDevice => 'LECTURE DEPUIS L\'APPAREIL';

  @override
  String get nowPlayingCollapsePlayer => 'Reduire le lecteur';

  @override
  String get nowPlayingTrackActionsTooltip => 'Actions du titre';

  @override
  String get nowPlayingAddToFavorites => 'Ajouter aux favoris';

  @override
  String get nowPlayingRemoveFromFavorites => 'Retirer des favoris';

  @override
  String get nowPlayingPause => 'Mettre en pause';

  @override
  String get nowPlayingResumeSemantic => 'Reprendre la lecture';

  @override
  String get nowPlayingSeekLabel => 'Position de lecture';

  @override
  String get nowPlayingVolumeLabel => 'Volume';

  @override
  String get nowPlayingSpeedLabel => 'Vitesse';

  @override
  String get nowPlayingEqLabel => 'EQ';

  @override
  String get nowPlayingShareLabel => 'Partager';

  @override
  String get nowPlayingDevicesLabel => 'Appareils';

  @override
  String get nowPlayingQueueLabel => 'File d\'attente';

  @override
  String get nowPlayingCopyTrackInfo => 'Copier les infos du titre';

  @override
  String get nowPlayingCopyQueueLabel =>
      'Copier toute la file comme liste de titres';

  @override
  String nowPlayingQueueCount(int count) {
    return '$count titres dans la file actuelle';
  }

  @override
  String get nowPlayingCopiedToClipboard =>
      'Infos du titre copiees dans le presse-papiers';

  @override
  String get nowPlayingQueueCopied =>
      'File d\'attente copiee dans le presse-papiers';

  @override
  String get nowPlayingThisDevice => 'Cet appareil';

  @override
  String get nowPlayingThisDeviceSubtitle =>
      'La lecture reste sur la sortie active du telephone.';

  @override
  String get nowPlayingBluetooth => 'Bluetooth ou diffusion';

  @override
  String get nowPlayingBluetoothSubtitle =>
      'Utilisez le selecteur de sortie du systeme pour deplacer la lecture. Stitch Music suit la route du systeme.';

  @override
  String get nowPlayingVolumeSheetTitle => 'Volume de lecture';

  @override
  String get nowPlayingVolumeSheetSubtitle =>
      'Ajustez le volume just_audio pour la session en cours.';

  @override
  String get nowPlayingSpeedSheetTitle => 'Vitesse de lecture';

  @override
  String get nowPlayingSpeedSheetSubtitle =>
      'Ralentissez pour les details ou accelerez pour la revue.';

  @override
  String get nowPlayingRemoveFavorite => 'Supprimer favori';

  @override
  String get nowPlayingAddFavorite => 'Ajouter favori';

  @override
  String get nowPlayingFavoriteSubtitle =>
      'Epinglez ce titre dans votre section Favoris.';

  @override
  String get nowPlayingAddToPlaylist => 'Ajouter a la liste';

  @override
  String get nowPlayingAddToPlaylistSubtitle =>
      'Enregistrez le titre actuel dans une de vos listes.';

  @override
  String get nowPlayingShareTrack => 'Partager le titre';

  @override
  String get nowPlayingShareTrackSubtitle =>
      'Copiez les details du titre ou la file active.';

  @override
  String get nowPlayingOpenInsights => 'Ouvrir les statistiques';

  @override
  String get nowPlayingOpenInsightsSubtitle =>
      'Consultez les statistiques et tendances d\'ecoute actuelles.';

  @override
  String get nowPlayingOpenSettings => 'Ouvrir les parametres';

  @override
  String get nowPlayingOpenSettingsSubtitle =>
      'Aller aux parametres EQ et de l\'application.';

  @override
  String get nowPlayingNoPlaylistsCreate =>
      'Aucune liste pour l\'instant. Creez-en une depuis l\'onglet Listes.';

  @override
  String nowPlayingAddedToPlaylist(String name) {
    return 'Ajoute a \"$name\"';
  }

  @override
  String get insightsTitle => 'Statistiques';

  @override
  String get insightsListeningHabits => 'HABITUDES D\'ECOUTE';

  @override
  String get insightsTopTracks => 'TITRES LES PLUS ECOUTES';

  @override
  String get insightsTopArtists => 'ARTISTES LES PLUS ECOUTES';

  @override
  String get insightsTotalPlays => 'Lectures totales';

  @override
  String get insightsListened => 'Ecoute';

  @override
  String get insightsInLibrary => 'Dans la bibliotheque';

  @override
  String get insightsFavorites => 'Favoris';

  @override
  String get insightsSkipRate => 'Taux de saut';

  @override
  String get insightsSkipRateNoData => 'Pas encore de donnees';

  @override
  String get insightsSkipRateLow =>
      'Faible — vous finissez ce que vous commencez 🎯';

  @override
  String get insightsSkipRateModerate => 'Modere — assez selectif';

  @override
  String get insightsSkipRateHigh => 'Eleve — beaucoup de sauts';

  @override
  String get insightsLast7Days => '7 derniers jours';

  @override
  String get insightsDayMon => 'Lun';

  @override
  String get insightsDayTue => 'Mar';

  @override
  String get insightsDayWed => 'Mer';

  @override
  String get insightsDayThu => 'Jeu';

  @override
  String get insightsDayFri => 'Ven';

  @override
  String get insightsDaySat => 'Sam';

  @override
  String get insightsDaySun => 'Dim';

  @override
  String get insightsNoTopTracks =>
      'Ecoutez des titres pour voir vos meilleurs titres';

  @override
  String get insightsNoTopArtists => 'Prochainement — ecoutez plus de titres';

  @override
  String insightsMinPlayed(int count) {
    return '$count min ecoutees';
  }

  @override
  String get insightsPlaySingular => 'lecture';

  @override
  String get insightsPlayPlural => 'lectures';

  @override
  String get insightsClearStats => 'Effacer toutes les statistiques';

  @override
  String get insightsClearTitle => 'Effacer toutes les statistiques ?';

  @override
  String get insightsClearContent =>
      'Cela supprime tout l\'historique de lecture et les donnees d\'analyse. Votre bibliotheque, listes et favoris ne sont pas affectes.';

  @override
  String get insightsCancelButton => 'Annuler';

  @override
  String get insightsClearButton => 'Effacer';

  @override
  String get playlistsTitle => 'Listes de lecture';

  @override
  String get playlistsSaveQueue => 'Enregistrer la file';

  @override
  String playlistsTrackCount(int count) {
    return '$count titres';
  }

  @override
  String get playlistsRenameTooltip => 'Renommer';

  @override
  String get playlistsDeleteTooltip => 'Supprimer la liste';

  @override
  String get playlistsPlayButton => 'Lire';

  @override
  String get playlistsEmptyTitle => 'Aucune liste pour l\'instant';

  @override
  String get playlistsEmptySubtitle =>
      'Ecoutez des titres de votre bibliotheque, puis enregistrez la file comme liste.';

  @override
  String get playlistsCreateFromQueue => 'Creer depuis la file';

  @override
  String get playlistsCreateTitle => 'Creer une liste';

  @override
  String get playlistsNameHint => 'Nom de la liste';

  @override
  String get playlistsCancelButton => 'Annuler';

  @override
  String get playlistsSaveButton => 'Enregistrer';

  @override
  String get playlistsQueueEmpty =>
      'La file est vide. Ecoutez d\'abord un titre.';

  @override
  String playlistsSaved(String name) {
    return 'Enregistre \"$name\"';
  }

  @override
  String playlistsDefaultName(String time) {
    return 'Ma liste $time';
  }

  @override
  String get playlistsRenameTitle => 'Renommer la liste';

  @override
  String get onlineSearchTitle => 'Recherche en ligne (YouTube)';

  @override
  String get onlineSearchDiscoveryNote =>
      'Decouverte uniquement. La lecture reste bloquee jusqu\'a ce que l\'auth et les droits officiels de l\'API soient disponibles.';

  @override
  String get onlineSearchProviderUnavailable =>
      'La configuration du fournisseur n\'est pas disponible.';

  @override
  String get onlineSearchEntitlementRequired =>
      'Des droits sont requis pour ce titre.';

  @override
  String get onlineSearchUriUnavailable =>
      'URI de lecture indisponible. Le backend reste ferme.';

  @override
  String onlineSearchPlayingNow(String title) {
    return 'Lecture de \"$title\" en cours.';
  }

  @override
  String onlineSearchAddedToQueue(String title) {
    return '\"$title\" ajoute a la file.';
  }

  @override
  String get onlineSearchRefreshEntitlement => 'Actualiser les droits';

  @override
  String get onlineSearchDemoModeLabel =>
      'Mode demo : resultats du fournisseur simules pour les tests UI';

  @override
  String get onlineSearchProductionModeLabel =>
      'Mode securise : ferme jusqu\'a ce que le backend officiel soit configure';

  @override
  String get onlineSearchHint => 'Rechercher des artistes, titres, chaines...';

  @override
  String get onlineSearchButton => 'Rechercher';

  @override
  String get onlineSearchEntitlementUnknown => 'Droits inconnus';

  @override
  String get onlineSearchEntitlementUnknownBody =>
      'Impossible de determiner l\'etat des droits du fournisseur.';

  @override
  String get onlineSearchSignInRequired => 'Connexion requise';

  @override
  String get onlineSearchSignInRequiredBody =>
      'Veuillez vous connecter avec le flux officiel du fournisseur.';

  @override
  String get onlineSearchPremiumRequired => 'Premium requis';

  @override
  String get onlineSearchPremiumRequiredBody =>
      'Le niveau de compte actuel ne permet pas la lecture dans l\'application.';

  @override
  String get onlineSearchUnavailableInRegion => 'Indisponible dans la region';

  @override
  String get onlineSearchUnavailableInRegionBody =>
      'La diffusion est restreinte pour votre region.';

  @override
  String get onlineSearchEntitled => 'Autorise';

  @override
  String get onlineSearchEntitledBody =>
      'Le compte semble eligible pour les verifications de lecture du fournisseur.';

  @override
  String get onlineSearchNoCatalog =>
      'Recherchez dans le catalogue en ligne pour decouvrir des titres.';

  @override
  String get onlineSearchNoResults => 'Aucun resultat trouve.';

  @override
  String get onlineSearchLockedBadge => 'Verrouille';

  @override
  String get onlineSearchOpenBadge => 'Libre';

  @override
  String get onlineSearchAddButton => 'Ajouter';

  @override
  String get onlineSearchPlayButton => 'Lire';
}
