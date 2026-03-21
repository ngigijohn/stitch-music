import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/music_models.dart';

enum QueueRepeatMode { none, one, all }

// ---------------------------------------------------------------------------
// Storage key registry — bump _kVersion to trigger migration of new fields.
// ---------------------------------------------------------------------------
const int _kVersion = 1;
const String _kQueueIds   = 'v${_kVersion}_queue_ids';
const String _kCurrentId  = 'v${_kVersion}_current_track_id';
const String _kPositionMs = 'v${_kVersion}_position_ms';
const String _kRepeatMode = 'v${_kVersion}_repeat_mode';
const String _kShuffle    = 'v${_kVersion}_shuffle_enabled';
const String _kFavorites  = 'v${_kVersion}_favorites';
const String _kRecents    = 'v${_kVersion}_recents';
const String _kPlaylists  = 'v${_kVersion}_playlists_json';
const int _kMaxRecents = 30;

class PlaybackController extends ChangeNotifier {
  PlaybackController._();
  static final PlaybackController instance = PlaybackController._();

  final AudioPlayer _player = AudioPlayer();
  static const MethodChannel _mediaChannel = MethodChannel('stitch_music/media_store');

  final List<Track> _library = [];
  final List<Track> _queue = [];
  final List<Playlist> _playlists = [];

  bool _initialized = false;
  bool _isScanning = false;
  String? _scanError;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  DateTime? _lastScanAt;
  int _currentIndex = -1;
  QueueRepeatMode _repeatMode = QueueRepeatMode.none;
  bool _shuffleEnabled = false;
  final Set<String> _favorites = {};
  final List<Track> _recents = [];

  Timer? _persistDebounce;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  List<Track> get library => List.unmodifiable(_library);
  List<Track> get queue => List.unmodifiable(_queue);
  List<Playlist> get playlists => List.unmodifiable(_playlists);
  bool get isScanning => _isScanning;
  String? get scanError => _scanError;
  PermissionStatus get permissionStatus => _permissionStatus;
  DateTime? get lastScanAt => _lastScanAt;
  bool get isPlaying => _player.playing;
  int get currentIndex => _currentIndex;
  Track? get currentTrack =>
      (_currentIndex >= 0 && _currentIndex < _queue.length) ? _queue[_currentIndex] : null;
  Duration get position => _position;
  Duration get duration => _duration;
  QueueRepeatMode get repeatMode => _repeatMode;
  bool get shuffleEnabled => _shuffleEnabled;
  List<String> get favorites => List.unmodifiable(_favorites.toList());
  List<Track> get recents => List.unmodifiable(_recents);
  bool isFavorite(String trackId) => _favorites.contains(trackId);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _positionSub = _player.positionStream.listen((p) {
      _position = p;
      if (_player.playing) {
        _schedulePersist();
      }
      notifyListeners();
    });

    _durationSub = _player.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      notifyListeners();
    });

    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleTrackCompleted();
        return;
      }
      notifyListeners();
    });

    await scanDeviceLibrary();
    await _restorePlaylists();
    await _restoreSessionState();
    await _restoreFavoritesAndRecents();
  }

  Future<bool> _ensurePermissions() async {
    if (!Platform.isAndroid) return true;

    var status = await Permission.audio.status;
    _permissionStatus = status;
    if (!status.isGranted) {
      status = await Permission.audio.request();
      _permissionStatus = status;
    }
    if (status.isGranted) return true;

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      storageStatus = await Permission.storage.request();
    }
    _permissionStatus = storageStatus;
    return storageStatus.isGranted;
  }

  Future<void> scanDeviceLibrary() async {
    _isScanning = true;
    _scanError = null;
    notifyListeners();

    try {
      final hasPermission = await _ensurePermissions();
      if (!hasPermission) {
        _scanError = 'Media permission denied. Please allow music access.';
        _isScanning = false;
        notifyListeners();
        return;
      }

      List<Track> tracks = [];
      if (Platform.isAndroid) {
        final dynamic raw = await _mediaChannel.invokeMethod('getDeviceSongs');
        final List<dynamic> list = (raw as List<dynamic>? ?? <dynamic>[]);
        tracks = list
            .whereType<Map<dynamic, dynamic>>()
            .map(Track.fromMediaStoreMap)
            .toList()
          ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      }

      _library
        ..clear()
        ..addAll(tracks);

      _lastScanAt = DateTime.now();

      if (_queue.isEmpty && _library.isNotEmpty) {
        _queue.addAll(_library);
      }

      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _scanError = 'Failed to load songs: $e';
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> playFromLibrary(Track track, {List<Track>? sourceList}) async {
    final List<Track> source = sourceList ?? _library;
    if (source.isEmpty) return;

    _queue
      ..clear()
      ..addAll(source);

    final int idx = _queue.indexWhere((t) => t.id == track.id);
    await playAtIndex(idx < 0 ? 0 : idx);
  }

  Future<void> playAtIndex(int index) async {
    if (index < 0 || index >= _queue.length) return;

    final Track track = _queue[index];
    final String? source = track.uri ?? track.filePath;
    if (source == null || source.isEmpty) {
      _scanError = 'Cannot play track source.';
      notifyListeners();
      return;
    }

    try {
      _currentIndex = index;
      _position = Duration.zero;
      _addToRecents(track);
      _addToRecents(track);
      final uri = source.startsWith('content://') ? Uri.parse(source) : Uri.file(source);
      await _player.setAudioSource(AudioSource.uri(uri));
      await _player.play();
      _schedulePersist();
      notifyListeners();
    } catch (e) {
      _scanError = 'Playback error: $e';
      notifyListeners();
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      if (_currentIndex < 0 && _queue.isNotEmpty) {
        await playAtIndex(0);
        return;
      }
      await _player.play();
    }
    _schedulePersist();
    notifyListeners();
  }

  Future<void> seekToFraction(double fraction) async {
    if (_duration.inMilliseconds <= 0) return;
    final int targetMs = (_duration.inMilliseconds * fraction).round();
    await _player.seek(Duration(milliseconds: targetMs));
    _schedulePersist();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
    _schedulePersist();
  }

  void toggleShuffle() {
    _shuffleEnabled = !_shuffleEnabled;
    notifyListeners();
  }

  void cycleRepeat() {
    _repeatMode = QueueRepeatMode.values[(_repeatMode.index + 1) % QueueRepeatMode.values.length];
    notifyListeners();
  }

  Future<void> skipNext() async {
    if (_queue.isEmpty) return;
    if (_shuffleEnabled) {
      final candidates = List.generate(_queue.length, (i) => i)
          .where((i) => i != _currentIndex)
          .toList();
      if (candidates.isEmpty) return;
      candidates.shuffle();
      await playAtIndex(candidates.first);
      return;
    }
    final int next = _currentIndex + 1;
    if (next < _queue.length) {
      await playAtIndex(next);
    } else if (_repeatMode == QueueRepeatMode.all) {
      await playAtIndex(0);
    }
  }

  Future<void> skipPrevious() async {
    if (_queue.isEmpty) return;
    if (_position.inSeconds > 3) {
      await seekTo(Duration.zero);
      return;
    }
    final int prev = _currentIndex - 1;
    if (prev >= 0) {
      await playAtIndex(prev);
    } else {
      await seekTo(Duration.zero);
    }
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < 0 || oldIndex >= _queue.length) return;
    if (newIndex < 0 || newIndex > _queue.length) return;
    if (newIndex > oldIndex) newIndex--;

    final Track moved = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, moved);

    if (_currentIndex == oldIndex) {
      _currentIndex = newIndex;
    } else if (_currentIndex > oldIndex && _currentIndex <= newIndex) {
      _currentIndex--;
    } else if (_currentIndex < oldIndex && _currentIndex >= newIndex) {
      _currentIndex++;
    }
    _schedulePersist();
    notifyListeners();
  }

  Future<void> toggleFavorite(String trackId) async {
    if (_favorites.contains(trackId)) {
      _favorites.remove(trackId);
    } else {
      _favorites.add(trackId);
    }
    await _saveFavoritesAndRecents();
    notifyListeners();
  }

  void _addToRecents(Track track) {
    _recents.removeWhere((t) => t.id == track.id);
    _recents.insert(0, track);
    if (_recents.length > _kMaxRecents) _recents.removeLast();
    _schedulePersist();
  }

  List<Track> tracksForPlaylist(String playlistId) {
    final Playlist? playlist = _playlists.cast<Playlist?>().firstWhere(
          (p) => p?.id == playlistId,
          orElse: () => null,
        );
    if (playlist == null) return const <Track>[];

    final List<Track> tracks = <Track>[];
    for (final id in playlist.trackIds) {
      final int idx = _library.indexWhere((t) => t.id == id);
      if (idx >= 0) tracks.add(_library[idx]);
    }
    return tracks;
  }

  Future<void> createPlaylistFromQueue(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty || _queue.isEmpty) return;

    final String id = 'pl_${DateTime.now().millisecondsSinceEpoch}';
    final List<String> ids = _queue.map((t) => t.id).toSet().toList();
    final Playlist playlist = Playlist(
      id: id,
      name: trimmed,
      trackIds: ids,
      createdAt: DateTime.now(),
    );

    _playlists.insert(0, playlist);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> renamePlaylist(String playlistId, String newName) async {
    final String trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    final int idx = _playlists.indexWhere((p) => p.id == playlistId);
    if (idx < 0) return;

    _playlists[idx] = _playlists[idx].copyWith(name: trimmed);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> deletePlaylist(String playlistId) async {
    _playlists.removeWhere((p) => p.id == playlistId);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    final int idx = _playlists.indexWhere((p) => p.id == playlistId);
    if (idx < 0) return;
    final playlist = _playlists[idx];
    if (playlist.trackIds.contains(trackId)) return;
    _playlists[idx] = playlist.copyWith(trackIds: [...playlist.trackIds, trackId]);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> removeTrackFromPlaylist(String playlistId, String trackId) async {
    final int idx = _playlists.indexWhere((p) => p.id == playlistId);
    if (idx < 0) return;
    final playlist = _playlists[idx];
    final updated = playlist.trackIds.where((id) => id != trackId).toList();
    _playlists[idx] = playlist.copyWith(trackIds: updated);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> reorderPlaylistTrack(String playlistId, int oldIndex, int newIndex) async {
    final int idx = _playlists.indexWhere((p) => p.id == playlistId);
    if (idx < 0) return;
    final ids = List<String>.from(_playlists[idx].trackIds);
    if (oldIndex < 0 || oldIndex >= ids.length) return;
    if (newIndex > oldIndex) newIndex--;
    final moved = ids.removeAt(oldIndex);
    ids.insert(newIndex, moved);
    _playlists[idx] = _playlists[idx].copyWith(trackIds: ids);
    await _savePlaylists();
    notifyListeners();
  }

  Future<void> playPlaylist(String playlistId, {int startIndex = 0}) async {
    final tracks = tracksForPlaylist(playlistId);
    if (tracks.isEmpty) {
      _scanError = 'Playlist has no available tracks on this device.';
      notifyListeners();
      return;
    }

    _queue
      ..clear()
      ..addAll(tracks);

    final int safeStart = startIndex.clamp(0, tracks.length - 1);
    await playAtIndex(safeStart);
  }

  Future<void> _handleTrackCompleted() async {
    if (_repeatMode == QueueRepeatMode.one) {
      await playAtIndex(_currentIndex);
      return;
    }
    if (_shuffleEnabled) {
      await skipNext();
      return;
    }
    final int next = _currentIndex + 1;
    if (next < _queue.length) {
      await playAtIndex(next);
      return;
    }
    if (_repeatMode == QueueRepeatMode.all) {
      await playAtIndex(0);
      return;
    }
    await _player.pause();
    await _player.seek(Duration.zero);
    _position = Duration.zero;
    _schedulePersist();
    notifyListeners();
  }

  void _schedulePersist() {
    _persistDebounce?.cancel();
    _persistDebounce = Timer(const Duration(milliseconds: 700), _saveSessionState);
  }

  Future<void> _saveSessionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kQueueIds, _queue.map((t) => t.id).toList());
      await prefs.setString(_kCurrentId, currentTrack?.id ?? '');
      await prefs.setInt(_kPositionMs, _position.inMilliseconds);
      await prefs.setInt(_kRepeatMode, _repeatMode.index);
      await prefs.setBool(_kShuffle, _shuffleEnabled);
    } catch (_) {
      // Keep runtime resilient if persistence fails.
    }
  }

  Future<void> _savePlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode(_playlists.map((p) => p.toMap()).toList());
      await prefs.setString(_kPlaylists, payload);
    } catch (_) {
      // Keep runtime resilient if persistence fails.
    }
  }

  Future<void> _saveFavoritesAndRecents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kFavorites, _favorites.toList());
      await prefs.setStringList(_kRecents, _recents.map((t) => t.id).toList());
    } catch (_) {}
  }

  Future<void> _restoreFavoritesAndRecents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favIds = prefs.getStringList(_kFavorites) ?? [];
      _favorites
        ..clear()
        ..addAll(favIds);
      final recentIds = prefs.getStringList(_kRecents) ?? [];
      _recents.clear();
      for (final id in recentIds) {
        final idx = _library.indexWhere((t) => t.id == id);
        if (idx >= 0) _recents.add(_library[idx]);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _restorePlaylists() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Migrate legacy key on first run with versioned storage.
      final String raw = prefs.getString(_kPlaylists) ?? prefs.getString('playlists_json') ?? '';
      if (raw.isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      final restored = <Playlist>[];
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          restored.add(Playlist.fromMap(item));
          continue;
        }
        if (item is Map) {
          restored.add(Playlist.fromMap(item.map((k, v) => MapEntry(k.toString(), v))));
        }
      }

      _playlists
        ..clear()
        ..addAll(restored);
    } catch (_) {
      // Restore is best-effort.
    }
  }

  Future<void> _restoreSessionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Migrate legacy keys on first run with versioned storage.
      final ids = prefs.getStringList(_kQueueIds) ?? prefs.getStringList('queue_ids') ?? [];
      final currentId = prefs.getString(_kCurrentId) ?? prefs.getString('current_track_id') ?? '';
      final posMs = prefs.getInt(_kPositionMs) ?? prefs.getInt('position_ms') ?? 0;

      if (ids.isNotEmpty) {
        final restored = <Track>[];
        for (final id in ids) {
          final idx = _library.indexWhere((t) => t.id == id);
          if (idx >= 0) restored.add(_library[idx]);
        }
        if (restored.isNotEmpty) {
          _queue
            ..clear()
            ..addAll(restored);
        }
      }

      if (_queue.isEmpty) return;

      int idx = _queue.indexWhere((t) => t.id == currentId);
      if (idx < 0) idx = 0;
      _currentIndex = idx;

      final track = _queue[_currentIndex];
      final source = track.uri ?? track.filePath;
      if (source == null || source.isEmpty) return;
      final uri = source.startsWith('content://') ? Uri.parse(source) : Uri.file(source);
      await _player.setAudioSource(AudioSource.uri(uri));
      if (posMs > 0) {
        await _player.seek(Duration(milliseconds: posMs));
      }
      final repeatIdx = prefs.getInt('repeat_mode') ?? 0;
      _repeatMode = QueueRepeatMode.values[repeatIdx.clamp(0, QueueRepeatMode.values.length - 1)];
      _shuffleEnabled = prefs.getBool('shuffle_enabled') ?? false;
      notifyListeners();
    } catch (_) {
      // Restore is best-effort.
    }
  }

  @visibleForTesting
  void loadQueueForTest(List<Track> tracks) {
    _library
      ..clear()
      ..addAll(tracks);
    _queue
      ..clear()
      ..addAll(tracks);
    _playlists.clear();
    _favorites.clear();
    _recents.clear();
    _currentIndex = -1;
    _scanError = null;
    notifyListeners();
  }

  Future<void> disposeController() async {
    _persistDebounce?.cancel();
    await _saveSessionState();
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.dispose();
  }
}
