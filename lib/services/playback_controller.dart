import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/music_models.dart';

class PlaybackController extends ChangeNotifier {
  PlaybackController._();
  static final PlaybackController instance = PlaybackController._();

  final AudioPlayer _player = AudioPlayer();
  static const MethodChannel _mediaChannel = MethodChannel('stitch_music/media_store');

  final List<Track> _library = [];
  final List<Track> _queue = [];

  bool _initialized = false;
  bool _isScanning = false;
  String? _scanError;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  DateTime? _lastScanAt;
  int _currentIndex = -1;

  bool _isShuffle = false;
  int _repeatMode = 0; // 0 = off, 1 = all, 2 = one

  Timer? _persistDebounce;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  List<Track> get library => List.unmodifiable(_library);
  List<Track> get queue => List.unmodifiable(_queue);
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
  bool get isShuffle => _isShuffle;
  int get repeatMode => _repeatMode;

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
    await _restoreSessionState();
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

  Future<void> skipNext() async {
    if (_queue.isEmpty) return;
    final int next = _currentIndex + 1;
    if (next < _queue.length) {
      await playAtIndex(next);
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

  void reorderQueue(int oldIndex, int newIndex) {
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

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    _schedulePersist();
    notifyListeners();
  }

  void cycleRepeat() {
    _repeatMode = (_repeatMode + 1) % 3;
    _schedulePersist();
    notifyListeners();
  }

  Future<void> _handleTrackCompleted() async {
    // Repeat one: restart the current track
    if (_repeatMode == 2) {
      await _player.seek(Duration.zero);
      await _player.play();
      return;
    }

    // Shuffle: pick a random next track
    if (_isShuffle && _queue.length > 1) {
      final rng = Random();
      int next;
      do {
        next = rng.nextInt(_queue.length);
      } while (next == _currentIndex);
      await playAtIndex(next);
      return;
    }

    final int next = _currentIndex + 1;
    if (next < _queue.length) {
      await playAtIndex(next);
      return;
    }

    // Repeat all: wrap back to first track
    if (_repeatMode == 1 && _queue.isNotEmpty) {
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
      await prefs.setStringList('queue_ids', _queue.map((t) => t.id).toList());
      await prefs.setString('current_track_id', currentTrack?.id ?? '');
      await prefs.setInt('position_ms', _position.inMilliseconds);
      await prefs.setBool('is_shuffle', _isShuffle);
      await prefs.setInt('repeat_mode', _repeatMode);
    } catch (_) {
      // Keep runtime resilient if persistence fails.
    }
  }

  Future<void> _restoreSessionState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList('queue_ids') ?? const <String>[];
      final currentId = prefs.getString('current_track_id') ?? '';
      final posMs = prefs.getInt('position_ms') ?? 0;

      _isShuffle = prefs.getBool('is_shuffle') ?? false;
      _repeatMode = prefs.getInt('repeat_mode') ?? 0;

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
      notifyListeners();
    } catch (_) {
      // Restore is best-effort.
    }
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
