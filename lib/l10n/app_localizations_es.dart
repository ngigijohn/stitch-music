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
}
