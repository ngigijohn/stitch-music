import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Persistence keys ─────────────────────────────────────────────────────────
const _kPlayEvents = 'v1_analytics_play_events';
const _kFavEvents  = 'v1_analytics_fav_events';

// ─── Max stored events (prevent unbounded growth) ────────────────────────────
const int _kMaxPlayEvents = 2000;
const int _kMaxFavEvents  = 500;

// ─── Event models ─────────────────────────────────────────────────────────────

class PlayEvent {
  final String trackId;
  final String title;
  final String artist;
  final String album;
  final int durationMs;
  final DateTime playedAt;
  final int secondsPlayed;
  final bool skipped;

  const PlayEvent({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationMs,
    required this.playedAt,
    required this.secondsPlayed,
    required this.skipped,
  });

  Map<String, dynamic> toJson() => {
        'trackId': trackId,
        'title': title,
        'artist': artist,
        'album': album,
        'durationMs': durationMs,
        'playedAt': playedAt.millisecondsSinceEpoch,
        'secondsPlayed': secondsPlayed,
        'skipped': skipped,
      };

  factory PlayEvent.fromJson(Map<String, dynamic> j) => PlayEvent(
        trackId: j['trackId'] as String,
        title: j['title'] as String,
        artist: j['artist'] as String,
        album: j['album'] as String,
        durationMs: j['durationMs'] as int,
        playedAt: DateTime.fromMillisecondsSinceEpoch(j['playedAt'] as int),
        secondsPlayed: j['secondsPlayed'] as int,
        skipped: j['skipped'] as bool,
      );
}

class FavoriteEvent {
  final String trackId;
  /// 'added' or 'removed'
  final String action;
  final DateTime at;

  const FavoriteEvent({
    required this.trackId,
    required this.action,
    required this.at,
  });

  Map<String, dynamic> toJson() => {
        'trackId': trackId,
        'action': action,
        'at': at.millisecondsSinceEpoch,
      };

  factory FavoriteEvent.fromJson(Map<String, dynamic> j) => FavoriteEvent(
        trackId: j['trackId'] as String,
        action: j['action'] as String,
        at: DateTime.fromMillisecondsSinceEpoch(j['at'] as int),
      );
}

// ─── Computed result types ─────────────────────────────────────────────────────

class TrackStat {
  final String trackId;
  final String title;
  final String artist;
  final int plays;
  final int totalSecondsPlayed;

  const TrackStat({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.plays,
    required this.totalSecondsPlayed,
  });
}

class ArtistStat {
  final String artist;
  final int plays;
  final int totalSecondsPlayed;

  const ArtistStat({
    required this.artist,
    required this.plays,
    required this.totalSecondsPlayed,
  });
}

/// Plays per calendar day for the last 7 days.
class DailyActivity {
  /// List of 7 entries, index 0 = oldest, index 6 = today.
  final List<int> playsByDay;

  const DailyActivity({required this.playsByDay});

  int get max => playsByDay.reduce((a, b) => a > b ? a : b);
}

// ─── Service ──────────────────────────────────────────────────────────────────

class AnalyticsService extends ChangeNotifier {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  final List<PlayEvent> _plays = [];
  final List<FavoriteEvent> _favs = [];

  bool _initialized = false;

  // ── Accessors ──────────────────────────────────────────────────────────────

  int get totalPlays => _plays.length;

  /// Total seconds actually listened.
  int get totalSecondsListened =>
      _plays.fold(0, (sum, e) => sum + e.secondsPlayed);

  /// Format totalSecondsListened as "Xh Ym" or "Ym".
  String get totalListenedFormatted {
    final h = totalSecondsListened ~/ 3600;
    final m = (totalSecondsListened % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  double get skipRate {
    if (_plays.isEmpty) return 0.0;
    final skipped = _plays.where((e) => e.skipped).length;
    return skipped / _plays.length;
  }

  List<TrackStat> topTracks({int limit = 5}) {
    final Map<String, _TrackAcc> acc = {};
    for (final e in _plays) {
      acc.putIfAbsent(e.trackId,
          () => _TrackAcc(title: e.title, artist: e.artist));
      acc[e.trackId]!.plays++;
      acc[e.trackId]!.seconds += e.secondsPlayed;
    }
    final list = acc.entries
        .map((entry) => TrackStat(
              trackId: entry.key,
              title: entry.value.title,
              artist: entry.value.artist,
              plays: entry.value.plays,
              totalSecondsPlayed: entry.value.seconds,
            ))
        .toList()
      ..sort((a, b) => b.plays.compareTo(a.plays));
    return list.take(limit).toList();
  }

  List<ArtistStat> topArtists({int limit = 5}) {
    final Map<String, _ArtistAcc> acc = {};
    for (final e in _plays) {
      acc.putIfAbsent(e.artist, () => _ArtistAcc());
      acc[e.artist]!.plays++;
      acc[e.artist]!.seconds += e.secondsPlayed;
    }
    final list = acc.entries
        .map((entry) => ArtistStat(
              artist: entry.key,
              plays: entry.value.plays,
              totalSecondsPlayed: entry.value.seconds,
            ))
        .toList()
      ..sort((a, b) => b.plays.compareTo(a.plays));
    return list.take(limit).toList();
  }

  DailyActivity get weeklyActivity {
    final now = DateTime.now();
    final counts = List<int>.filled(7, 0);
    for (final e in _plays) {
      final delta = now.difference(e.playedAt).inDays;
      if (delta >= 0 && delta < 7) {
        counts[6 - delta]++;
      }
    }
    return DailyActivity(playsByDay: counts);
  }

  // ── Mutation ───────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _load();
  }

  /// Call when a track starts playing.
  void recordPlayStart({
    required String trackId,
    required String title,
    required String artist,
    required String album,
    required int durationMs,
  }) {
    _pendingPlay = _PendingPlay(
      trackId: trackId,
      title: title,
      artist: artist,
      album: album,
      durationMs: durationMs,
      startedAt: DateTime.now(),
    );
  }

  /// Call when a track ends (either completed or skipped).
  /// [secondsPlayed] = how far into the track we got.
  void recordPlayEnd({required int secondsPlayed, required bool skipped}) {
    final p = _pendingPlay;
    if (p == null) return;
    _pendingPlay = null;

    final event = PlayEvent(
      trackId: p.trackId,
      title: p.title,
      artist: p.artist,
      album: p.album,
      durationMs: p.durationMs,
      playedAt: p.startedAt,
      secondsPlayed: secondsPlayed,
      skipped: skipped,
    );

    _plays.insert(0, event);
    if (_plays.length > _kMaxPlayEvents) _plays.removeLast();
    _saveAsync();
    notifyListeners();
  }

  void recordFavorite({required String trackId, required bool added}) {
    final event = FavoriteEvent(
      trackId: trackId,
      action: added ? 'added' : 'removed',
      at: DateTime.now(),
    );
    _favs.insert(0, event);
    if (_favs.length > _kMaxFavEvents) _favs.removeLast();
    _saveAsync();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _plays.clear();
    _favs.clear();
    _pendingPlay = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPlayEvents);
    await prefs.remove(_kFavEvents);
    notifyListeners();
  }

  // ── Persistence ───────────────────────────────────────────────────────────

  _PendingPlay? _pendingPlay;

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final playJson = prefs.getStringList(_kPlayEvents) ?? [];
      for (final s in playJson) {
        try {
          _plays.add(PlayEvent.fromJson(jsonDecode(s) as Map<String, dynamic>));
        } catch (_) {
          // Silently skip malformed entries
        }
      }
      final favJson = prefs.getStringList(_kFavEvents) ?? [];
      for (final s in favJson) {
        try {
          _favs.add(FavoriteEvent.fromJson(jsonDecode(s) as Map<String, dynamic>));
        } catch (_) {}
      }
    } catch (_) {
      // Non-fatal — start fresh if prefs are unavailable
    }
    notifyListeners();
  }

  void _saveAsync() {
    // Fire-and-forget; uses a microtask to avoid blocking callers.
    Future.microtask(_save);
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _kPlayEvents,
        _plays.take(_kMaxPlayEvents).map((e) => jsonEncode(e.toJson())).toList(),
      );
      await prefs.setStringList(
        _kFavEvents,
        _favs.take(_kMaxFavEvents).map((e) => jsonEncode(e.toJson())).toList(),
      );
    } catch (_) {}
  }
}

// ─── Internal accumulators ────────────────────────────────────────────────────

class _TrackAcc {
  final String title;
  final String artist;
  int plays = 0;
  int seconds = 0;
  _TrackAcc({required this.title, required this.artist});
}

class _ArtistAcc {
  int plays = 0;
  int seconds = 0;
}

class _PendingPlay {
  final String trackId;
  final String title;
  final String artist;
  final String album;
  final int durationMs;
  final DateTime startedAt;
  const _PendingPlay({
    required this.trackId,
    required this.title,
    required this.artist,
    required this.album,
    required this.durationMs,
    required this.startedAt,
  });
}
