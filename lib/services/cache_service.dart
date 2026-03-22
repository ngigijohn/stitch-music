import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Persistence keys ─────────────────────────────────────────────────────────
const _kOfflineMode  = 'v1_offline_mode';
const _kPinnedTracks = 'v1_pinned_track_ids';
const _kCacheLimitMb = 'v1_cache_limit_mb';

// ─── Defaults ─────────────────────────────────────────────────────────────────
const int _kDefaultLimitMb = 200;

// ─── Service ──────────────────────────────────────────────────────────────────

/// Manages offline mode and the set of "pinned" tracks.
///
/// For the current app (local-device music), being "online" just means
/// cloud/search features are available. Pinning a track marks it for
/// guaranteed offline availability — practically important once streaming
/// is added (the streaming adapter layer will respect [pinnedIds]).
///
/// All state is persisted to SharedPreferences and survives restarts.
class CacheService extends ChangeNotifier {
  CacheService._();
  static final CacheService instance = CacheService._();

  bool _offlineMode = false;
  final Set<String> _pinnedIds = {};
  int _limitMb = _kDefaultLimitMb;
  bool _initialized = false;

  // ── Accessors ────────────────────────────────────────────────────────────────

  /// Whether cloud/online features are disabled.
  bool get isOfflineMode => _offlineMode;

  /// IDs of tracks pinned for offline use.
  Set<String> get pinnedIds => Set.unmodifiable(_pinnedIds);

  bool isPinned(String trackId) => _pinnedIds.contains(trackId);

  int get pinnedCount => _pinnedIds.length;

  /// User-configured cache size cap (MB). Defaults to 200 MB.
  int get limitMb => _limitMb;

  // ── Mutation ─────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _load();
  }

  Future<void> setOfflineMode(bool value) async {
    if (_offlineMode == value) return;
    _offlineMode = value;
    notifyListeners();
    await _save();
  }

  Future<void> pinTrack(String trackId) async {
    if (_pinnedIds.contains(trackId)) return;
    _pinnedIds.add(trackId);
    notifyListeners();
    await _save();
  }

  Future<void> unpinTrack(String trackId) async {
    if (!_pinnedIds.contains(trackId)) return;
    _pinnedIds.remove(trackId);
    notifyListeners();
    await _save();
  }

  Future<void> togglePin(String trackId) async {
    if (_pinnedIds.contains(trackId)) {
      await unpinTrack(trackId);
    } else {
      await pinTrack(trackId);
    }
  }

  Future<void> setLimitMb(int mb) async {
    final clamped = mb.clamp(10, 2000);
    if (_limitMb == clamped) return;
    _limitMb = clamped;
    notifyListeners();
    await _save();
  }

  Future<void> clearAll() async {
    _pinnedIds.clear();
    _offlineMode = false;
    _limitMb = _kDefaultLimitMb;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kOfflineMode);
    await prefs.remove(_kPinnedTracks);
    await prefs.remove(_kCacheLimitMb);
    notifyListeners();
  }

  @visibleForTesting
  Future<void> debugResetForTests() async {
    _initialized = false;
    _offlineMode = false;
    _pinnedIds.clear();
    _limitMb = _kDefaultLimitMb;
    await init();
  }

  // ── Persistence ───────────────────────────────────────────────────────────────

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _offlineMode = prefs.getBool(_kOfflineMode) ?? false;
      _pinnedIds
        ..clear()
        ..addAll(prefs.getStringList(_kPinnedTracks) ?? []);
      _limitMb = prefs.getInt(_kCacheLimitMb) ?? _kDefaultLimitMb;
    } catch (_) {
      // Non-fatal — defaults are already set
    }
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kOfflineMode, _offlineMode);
      await prefs.setStringList(_kPinnedTracks, _pinnedIds.toList());
      await prefs.setInt(_kCacheLimitMb, _limitMb);
    } catch (_) {}
  }
}
