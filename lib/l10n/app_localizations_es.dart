// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Stitch Music';

  @override
  String get navHome => 'Inicio';

  @override
  String get navDiscover => 'Descubrir';

  @override
  String get navLibrary => 'Biblioteca';

  @override
  String get navProfile => 'Perfil';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileDisplayName => 'Amante de la musica';

  @override
  String get profileSongs => 'Canciones';

  @override
  String get profileArtists => 'Artistas';

  @override
  String get profileHours => 'Horas';

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get profileHistory => 'Historial de reproduccion';

  @override
  String get profileDownloads => 'Descargas';

  @override
  String get profileSettings => 'Configuracion';

  @override
  String get libraryTitle => 'Tu biblioteca';

  @override
  String get libraryRescanTooltip => 'Volver a escanear el dispositivo';

  @override
  String get libraryOnlineSearchTooltip => 'Busqueda en linea (YouTube)';

  @override
  String get libraryOnlineSearchTitle => 'Busqueda en linea';

  @override
  String get libraryOnlineSearchDescription =>
      'Busca resultados de descubrimiento de YouTube en modo demo o seguro.';

  @override
  String get openLabel => 'Abrir';

  @override
  String get librarySearchHint => 'Buscar canciones, artistas, albumes...';

  @override
  String get libraryFilterAll => 'Todo';

  @override
  String get libraryFilterSongs => 'Canciones';

  @override
  String get libraryFilterAlbums => 'Albumes';

  @override
  String get libraryFilterArtists => 'Artistas';

  @override
  String songsCount(int count) {
    return '$count canciones';
  }

  @override
  String songsDetectedCount(int count) {
    return 'Canciones detectadas: $count';
  }

  @override
  String get mediaAccessGranted => 'Acceso multimedia concedido';

  @override
  String get permissionPermanentlyDenied => 'Permiso denegado permanentemente';

  @override
  String get mediaPermissionRequired => 'Se requiere permiso multimedia';

  @override
  String get scanningStatus => 'Escaneando...';

  @override
  String get idleStatus => 'Inactivo';

  @override
  String lastScan(String value) {
    return 'Ultimo escaneo: $value';
  }

  @override
  String get neverLabel => 'Nunca';

  @override
  String get retryLabel => 'Reintentar';

  @override
  String get openAppSettings => 'Abrir configuracion de la app';

  @override
  String get grantMusicPermission => 'Conceder permiso de musica';

  @override
  String get settingsLanguageSection => 'Idioma';

  @override
  String get settingsLanguageLabel => 'Idioma de la app';

  @override
  String get settingsLanguageSystem => 'Predeterminado del sistema';

  @override
  String get settingsLanguageEnglish => 'Ingles';

  @override
  String get settingsLanguageSpanish => 'Espanol';

  @override
  String get settingsLanguageFrench => 'Frances';

  @override
  String get settingsLanguageGerman => 'Aleman';

  @override
  String get settingsAccessibilitySection => 'Accesibilidad';

  @override
  String get settingsHighContrastTitle => 'Modo de alto contraste';

  @override
  String get settingsHighContrastSubtitle =>
      'Aumenta el contraste para texto y superficies clave';

  @override
  String get settingsTextScaleTitle => 'Tamano de texto';

  @override
  String get settingsTextScaleSubtitle => 'Escala el texto en toda la app';

  @override
  String get settingsTextScaleReset => 'Restablecer tamano de texto';

  @override
  String get settingsAccessibilityRoadmapTitle =>
      'Mas controles de accesibilidad';

  @override
  String get settingsAccessibilityRoadmapSubtitle =>
      'Semantica para lector de pantalla, ajustes de foco y mejoras de escala de texto en progreso';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsOfflineTitle => 'Modo sin conexion y cache';

  @override
  String get settingsOfflineSubtitle =>
      'Gestiona pines, limites de cache y comportamiento sin conexion';

  @override
  String get settingsAudioSection => 'Efectos de audio';

  @override
  String get settingsEqTitle => 'Ecualizador';

  @override
  String get settingsEnabledLabel => 'Activo';

  @override
  String get settingsDisabledLabel => 'Desactivado';

  @override
  String get settingsPresetLabel => 'Preajuste';

  @override
  String get settingsCustomEqLabel => 'EQ personalizado';

  @override
  String get settingsResetEq => 'Restablecer a plano';

  @override
  String get homeAppBarTitle => 'The Sonic Gallery';

  @override
  String get homeOpenQuickActions => 'Abrir acciones rapidas';

  @override
  String get homeQaSettings => 'Configuracion';

  @override
  String get homeQaSettingsSubtitle =>
      'Audio, localizacion y controles de la app';

  @override
  String get homeQaCacheOffline => 'Cache y sin conexion';

  @override
  String get homeQaCacheOfflineSubtitle =>
      'Pistas fijadas, modo sin conexion y tamano de cache';

  @override
  String get homeQaInsights => 'Estadisticas';

  @override
  String get homeQaInsightsSubtitle =>
      'Estadisticas de reproduccion y tendencias de escucha';

  @override
  String get homeQaProfile => 'Perfil';

  @override
  String get homeQaProfileSubtitle =>
      'Abrir el hub de perfil y las acciones de cuenta';

  @override
  String get homeOnlineDiscoveryTitle => 'Descubrimiento en linea';

  @override
  String get homeOnlineDiscoveryDescription =>
      'Explora la busqueda de YouTube en modo demo mientras la integracion oficial de la API permanece bloqueada.';

  @override
  String get homeOnlineDiscoveryChipDemo => 'Resultados demo';

  @override
  String get homeOnlineDiscoveryChipEntitlement => 'Banners de permiso';

  @override
  String get homeOnlineDiscoveryChipPolicy => 'Compatible con politicas';

  @override
  String get homeOpenOnlineSearch => 'Abrir busqueda en linea';

  @override
  String get homeNoPlaybackYet =>
      'La reproduccion aun no esta habilitada aqui.';

  @override
  String get homeHeroReadyToPlay => 'LISTO PARA REPRODUCIR';

  @override
  String get homeHeroNowPlayingBadge => 'REPRODUCIENDO AHORA';

  @override
  String get homeHeroDefaultTitle => 'Inicia tu sesion';

  @override
  String get homeHeroDefaultSubtitle =>
      'Reproduce algo de tu biblioteca y tu pista actual aparecera aqui.';

  @override
  String get homeHeroOpenPlayer => 'Abrir reproductor';

  @override
  String get homeHeroResume => 'Continuar';

  @override
  String get homeRecentPlaysTitle => 'Reproducciones recientes';

  @override
  String get homeRecentPlaysEmpty => 'Sin reproducciones locales recientes';

  @override
  String get homeRecentPlaysEmptySubtitle =>
      'Reproduce algo de tu biblioteca y aparecera aqui.';

  @override
  String get homeFavoriteTracksTitle => 'Pistas favoritas';

  @override
  String get homeFavoriteTracksEmpty => 'Sin favoritos aun';

  @override
  String get homeFavoriteTracksEmptySubtitle =>
      'Toca el corazon en Reproduciendo ahora para guardar tus mejores pistas.';

  @override
  String get homeRecentSearchesTitle => 'Busquedas en linea recientes';

  @override
  String get homeRecentSearchesEmpty => 'Sin busquedas en linea aun';

  @override
  String get homeRecentSearchesEmptySubtitle =>
      'Realiza una busqueda en Descubrimiento y aparecera aqui.';

  @override
  String get homeSearchDemoMode => 'Modo demo';

  @override
  String get homeSearchSafeMode => 'Modo seguro';

  @override
  String homeSearchResultCount(int count) {
    return '$count resultados';
  }

  @override
  String get homeDailyMixesTitle => 'Mezclas diarias';

  @override
  String get homeSeeAll => 'Ver todo';

  @override
  String get homePlayMore => 'Reproduce mas';

  @override
  String get homeNewReleasesTitle => 'Nuevos lanzamientos';

  @override
  String get homeAlbumOfWeek => 'Album de la semana';

  @override
  String get homeExploreAlbum => 'Explorar album';

  @override
  String get nowPlayingNothingPlaying => 'Nada se esta reproduciendo.';

  @override
  String get nowPlayingFromDevice => 'REPRODUCIENDO DESDE DISPOSITIVO';

  @override
  String get nowPlayingCollapsePlayer => 'Minimizar reproductor';

  @override
  String get nowPlayingTrackActionsTooltip => 'Acciones de pista';

  @override
  String get nowPlayingAddToFavorites => 'Anadir a favoritos';

  @override
  String get nowPlayingRemoveFromFavorites => 'Quitar de favoritos';

  @override
  String get nowPlayingPause => 'Pausar reproduccion';

  @override
  String get nowPlayingResumeSemantic => 'Reanudar reproduccion';

  @override
  String get nowPlayingSeekLabel => 'Posicion de reproduccion';

  @override
  String get nowPlayingVolumeLabel => 'Volumen';

  @override
  String get nowPlayingSpeedLabel => 'Velocidad';

  @override
  String get nowPlayingEqLabel => 'EQ';

  @override
  String get nowPlayingShareLabel => 'Compartir';

  @override
  String get nowPlayingDevicesLabel => 'Dispositivos';

  @override
  String get nowPlayingQueueLabel => 'Cola';

  @override
  String get nowPlayingCopyTrackInfo => 'Copiar info de pista';

  @override
  String get nowPlayingCopyQueueLabel =>
      'Copiar toda la cola como lista de pistas';

  @override
  String nowPlayingQueueCount(int count) {
    return '$count pistas en la cola actual';
  }

  @override
  String get nowPlayingCopiedToClipboard =>
      'Informacion de pista copiada al portapapeles';

  @override
  String get nowPlayingQueueCopied => 'Cola copiada al portapapeles';

  @override
  String get nowPlayingThisDevice => 'Este dispositivo';

  @override
  String get nowPlayingThisDeviceSubtitle =>
      'La reproduccion actual permanece en la salida activa del telefono.';

  @override
  String get nowPlayingBluetooth => 'Ruta Bluetooth o transmision';

  @override
  String get nowPlayingBluetoothSubtitle =>
      'Usa el selector de salida de medios del sistema para mover la reproduccion. Stitch Music sigue la ruta del sistema.';

  @override
  String get nowPlayingVolumeSheetTitle => 'Volumen de reproduccion';

  @override
  String get nowPlayingVolumeSheetSubtitle =>
      'Ajusta el volumen de salida de just_audio para la sesion actual.';

  @override
  String get nowPlayingSpeedSheetTitle => 'Velocidad de reproduccion';

  @override
  String get nowPlayingSpeedSheetSubtitle =>
      'Reduce la velocidad para mayor detalle o aumenta para revision.';

  @override
  String get nowPlayingRemoveFavorite => 'Quitar favorito';

  @override
  String get nowPlayingAddFavorite => 'Agregar favorito';

  @override
  String get nowPlayingFavoriteSubtitle =>
      'Fija esta pista en tu seccion de Favoritos.';

  @override
  String get nowPlayingAddToPlaylist => 'Anadir a lista';

  @override
  String get nowPlayingAddToPlaylistSubtitle =>
      'Guarda la pista actual en una de tus listas.';

  @override
  String get nowPlayingShareTrack => 'Compartir pista';

  @override
  String get nowPlayingShareTrackSubtitle =>
      'Copia los detalles de la pista o la cola activa.';

  @override
  String get nowPlayingOpenInsights => 'Abrir estadisticas';

  @override
  String get nowPlayingOpenInsightsSubtitle =>
      'Revisa las estadisticas y tendencias de escucha actuales.';

  @override
  String get nowPlayingOpenSettings => 'Abrir configuracion';

  @override
  String get nowPlayingOpenSettingsSubtitle =>
      'Ve al EQ y la configuracion de controles de la app.';

  @override
  String get nowPlayingNoPlaylistsCreate =>
      'Sin listas aun. Crea una desde la pestana de Listas.';

  @override
  String nowPlayingAddedToPlaylist(String name) {
    return 'Anadido a \"$name\"';
  }

  @override
  String get insightsTitle => 'Estadisticas';

  @override
  String get insightsListeningHabits => 'HABITOS DE ESCUCHA';

  @override
  String get insightsTopTracks => 'PISTAS MAS ESCUCHADAS';

  @override
  String get insightsTopArtists => 'ARTISTAS MAS ESCUCHADOS';

  @override
  String get insightsTotalPlays => 'Reproducciones totales';

  @override
  String get insightsListened => 'Escuchado';

  @override
  String get insightsInLibrary => 'En biblioteca';

  @override
  String get insightsFavorites => 'Favoritos';

  @override
  String get insightsSkipRate => 'Tasa de omision';

  @override
  String get insightsSkipRateNoData => 'Sin datos aun';

  @override
  String get insightsSkipRateLow => 'Baja — terminas lo que empiezas 🎯';

  @override
  String get insightsSkipRateModerate => 'Moderada — bastante selectivo';

  @override
  String get insightsSkipRateHigh => 'Alta — omites mucho';

  @override
  String get insightsLast7Days => 'Ultimos 7 dias';

  @override
  String get insightsDayMon => 'Lun';

  @override
  String get insightsDayTue => 'Mar';

  @override
  String get insightsDayWed => 'Mie';

  @override
  String get insightsDayThu => 'Jue';

  @override
  String get insightsDayFri => 'Vie';

  @override
  String get insightsDaySat => 'Sab';

  @override
  String get insightsDaySun => 'Dom';

  @override
  String get insightsNoTopTracks =>
      'Reproduce algunas pistas para ver tus pistas favoritas';

  @override
  String get insightsNoTopArtists => 'Proximamente — reproduce mas pistas';

  @override
  String insightsMinPlayed(int count) {
    return '$count min reproducidos';
  }

  @override
  String get insightsPlaySingular => 'reproduccion';

  @override
  String get insightsPlayPlural => 'reproducciones';

  @override
  String get insightsClearStats => 'Borrar todas las estadisticas';

  @override
  String get insightsClearTitle => 'Borrar todas las estadisticas?';

  @override
  String get insightsClearContent =>
      'Esto elimina todo el historial de reproduccion y los datos de analitica. Tu biblioteca, listas y favoritos no se veran afectados.';

  @override
  String get insightsCancelButton => 'Cancelar';

  @override
  String get insightsClearButton => 'Borrar';

  @override
  String get playlistsTitle => 'Listas de reproduccion';

  @override
  String get playlistsSaveQueue => 'Guardar cola';

  @override
  String playlistsTrackCount(int count) {
    return '$count pistas';
  }

  @override
  String get playlistsRenameTooltip => 'Renombrar';

  @override
  String get playlistsDeleteTooltip => 'Eliminar lista';

  @override
  String get playlistsPlayButton => 'Reproducir';

  @override
  String get playlistsEmptyTitle => 'Sin listas aun';

  @override
  String get playlistsEmptySubtitle =>
      'Reproduce canciones de tu biblioteca y guarda la cola como lista.';

  @override
  String get playlistsCreateFromQueue => 'Crear desde la cola';

  @override
  String get playlistsCreateTitle => 'Crear lista';

  @override
  String get playlistsNameHint => 'Nombre de la lista';

  @override
  String get playlistsCancelButton => 'Cancelar';

  @override
  String get playlistsSaveButton => 'Guardar';

  @override
  String get playlistsQueueEmpty =>
      'La cola esta vacia. Reproduce algo primero.';

  @override
  String playlistsSaved(String name) {
    return 'Guardado \"$name\"';
  }

  @override
  String playlistsDefaultName(String time) {
    return 'Mi lista $time';
  }

  @override
  String get playlistsRenameTitle => 'Renombrar lista';

  @override
  String get onlineSearchTitle => 'Busqueda en linea (YouTube)';

  @override
  String get onlineSearchDiscoveryNote =>
      'Solo descubrimiento. La reproduccion permanece bloqueada hasta que auth y permisos oficiales de API esten disponibles.';

  @override
  String get onlineSearchProviderUnavailable =>
      'La configuracion del proveedor no esta disponible.';

  @override
  String get onlineSearchEntitlementRequired =>
      'Se requiere permiso para esta pista.';

  @override
  String get onlineSearchUriUnavailable =>
      'URI de reproduccion no disponible. El backend permanece bloqueado.';

  @override
  String onlineSearchPlayingNow(String title) {
    return 'Reproduciendo \"$title\" ahora.';
  }

  @override
  String onlineSearchAddedToQueue(String title) {
    return 'Anadido \"$title\" a la cola.';
  }

  @override
  String get onlineSearchRefreshEntitlement => 'Actualizar permiso';

  @override
  String get onlineSearchDemoModeLabel =>
      'Modo demo: resultados del proveedor simulados para pruebas de UI';

  @override
  String get onlineSearchProductionModeLabel =>
      'Modo seguro de produccion: bloqueado hasta que el backend oficial este configurado';

  @override
  String get onlineSearchHint => 'Buscar artistas, canciones, canales...';

  @override
  String get onlineSearchButton => 'Buscar';

  @override
  String get onlineSearchEntitlementUnknown => 'Permiso desconocido';

  @override
  String get onlineSearchEntitlementUnknownBody =>
      'No se pudo determinar el estado de permiso del proveedor.';

  @override
  String get onlineSearchSignInRequired => 'Se requiere inicio de sesion';

  @override
  String get onlineSearchSignInRequiredBody =>
      'Por favor, inicia sesion con el flujo oficial del proveedor.';

  @override
  String get onlineSearchPremiumRequired => 'Se requiere premium';

  @override
  String get onlineSearchPremiumRequiredBody =>
      'El nivel de cuenta actual no permite la reproduccion en la app.';

  @override
  String get onlineSearchUnavailableInRegion => 'No disponible en la region';

  @override
  String get onlineSearchUnavailableInRegionBody =>
      'La transmision esta restringida para tu region.';

  @override
  String get onlineSearchEntitled => 'Autorizado';

  @override
  String get onlineSearchEntitledBody =>
      'La cuenta parece elegible para las verificaciones de reproduccion del proveedor.';

  @override
  String get onlineSearchNoCatalog =>
      'Busca en el catalogo en linea para descubrir pistas.';

  @override
  String get onlineSearchNoResults => 'No se encontraron resultados.';

  @override
  String get onlineSearchLockedBadge => 'Bloqueado';

  @override
  String get onlineSearchOpenBadge => 'Libre';

  @override
  String get onlineSearchAddButton => 'Anadir';

  @override
  String get onlineSearchPlayButton => 'Reproducir';
}
