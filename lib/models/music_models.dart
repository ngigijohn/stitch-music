import 'package:flutter/material.dart';

class Track {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String duration;
  final int durationMs;
  final String? uri;
  final String? filePath;
  final int? songId;
  final Color dominantColor;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    this.durationMs = 0,
    this.uri,
    this.filePath,
    this.songId,
    this.dominantColor = const Color(0xFF7C4DFF),
  });

  factory Track.fromMediaStoreMap(Map<dynamic, dynamic> map) {
    final int durationMs = _asInt(map['duration']);
    return Track(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? 'Unknown Track').toString(),
      artist: (map['artist'] ?? 'Unknown Artist').toString(),
      album: (map['album'] ?? 'Unknown Album').toString(),
      duration: _formatMs(durationMs),
      durationMs: durationMs,
      uri: map['uri']?.toString(),
      filePath: map['data']?.toString(),
      songId: _asNullableInt(map['id']),
      dominantColor: const Color(0xFF7C4DFF),
    );
  }

  factory Track.fromFilePath({
    required String id,
    required String title,
    required String path,
  }) {
    return Track(
      id: id,
      title: title,
      artist: 'Unknown Artist',
      album: 'Local Files',
      duration: '0:00',
      durationMs: 0,
      uri: path,
      filePath: path,
      dominantColor: const Color(0xFF7C4DFF),
    );
  }

  static int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static int? _asNullableInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    return null;
  }

  static String _formatMs(int ms) {
    if (ms <= 0) return '0:00';
    final Duration d = Duration(milliseconds: ms);
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

}

class Mix {
  final String id;
  final String title;
  final String description;
  final Color color;

  const Mix({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
  });
}

class Playlist {
  final String id;
  final String name;
  final List<String> trackIds;
  final DateTime createdAt;

  const Playlist({
    required this.id,
    required this.name,
    required this.trackIds,
    required this.createdAt,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    final rawTrackIds = (map['trackIds'] as List<dynamic>? ?? const <dynamic>[])
        .map((e) => e.toString())
        .where((e) => e.isNotEmpty)
        .toList();

    return Playlist(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Untitled Playlist').toString(),
      trackIds: rawTrackIds,
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'trackIds': trackIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Playlist copyWith({
    String? name,
    List<String>? trackIds,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      trackIds: trackIds ?? this.trackIds,
      createdAt: createdAt,
    );
  }
}

// ---------- Sample data ----------
const List<Track> kQueueTracks = [
  Track(id: '1', title: 'Neon Horizon', artist: 'Stellar Echo', album: 'Midnight Circuits', duration: '4:08', dominantColor: Color(0xFF7C4DFF)),
  Track(id: '2', title: 'Prism Eyes', artist: 'Aether & Neon', album: 'Refraction', duration: '3:45', dominantColor: Color(0xFF9C5CFF)),
  Track(id: '3', title: 'Midnight Euphoria', artist: 'The Sonic Gallery', album: 'Night Sessions', duration: '5:22', dominantColor: Color(0xFF6A3FC8)),
  Track(id: '4', title: 'Velvet Clouds', artist: 'Luminous Theory', album: 'Velvet Clouds', duration: '4:55', dominantColor: Color(0xFF8B5CF6)),
  Track(id: '5', title: 'Deep Blue', artist: 'Marina Shore', album: 'Oceanic', duration: '3:58', dominantColor: Color(0xFF4C6EF5)),
  Track(id: '6', title: 'Vibe Check', artist: 'The Collective', album: 'Frequencies', duration: '3:30', dominantColor: Color(0xFFBD34FE)),
  Track(id: '7', title: 'Late Night Drive', artist: 'Solaris', album: 'Drive', duration: '4:12', dominantColor: Color(0xFF7C4DFF)),
  Track(id: '8', title: 'Electric Soul', artist: 'Echo Chamber', album: 'Resonance', duration: '5:01', dominantColor: Color(0xFF9D44E8)),
];

const List<Track> kLibraryTracks = [
  Track(id: 'l1', title: 'Gravity Pull', artist: 'Nova Rise', album: 'Celestial', duration: '4:20', dominantColor: Color(0xFF7C4DFF)),
  Track(id: 'l2', title: 'Spectral Bloom', artist: 'Prism', album: 'Refracted Light', duration: '3:55', dominantColor: Color(0xFF5E35B1)),
  Track(id: 'l3', title: 'Aurora', artist: 'Midnight Sun', album: 'Northern Lights', duration: '6:10', dominantColor: Color(0xFF3949AB)),
  Track(id: 'l4', title: 'Neon Horizon', artist: 'Stellar Echo', album: 'Midnight Circuits', duration: '4:08', dominantColor: Color(0xFF7C4DFF)),
  Track(id: 'l5', title: 'Prism Eyes', artist: 'Aether & Neon', album: 'Refraction', duration: '3:45', dominantColor: Color(0xFF9C5CFF)),
  Track(id: 'l6', title: 'Deep Blue', artist: 'Marina Shore', album: 'Oceanic', duration: '3:58', dominantColor: Color(0xFF4C6EF5)),
];

const List<Mix> kDailyMixes = [
  Mix(id: 'm1', title: 'Electronic Focus', description: 'Deep house and ambient techno for deep work sessions.', color: Color(0xFF7C4DFF)),
  Mix(id: 'm2', title: 'Alternative Flow', description: 'Indie gems and underground hits from around the globe.', color: Color(0xFF9C5CFF)),
  Mix(id: 'm3', title: 'Classic Grooves', description: 'The foundation of soul, funk, and vintage jazz.', color: Color(0xFF6A3FC8)),
  Mix(id: 'm4', title: 'Chill Pulse', description: 'Soft beats and atmospheric pads for late nights.', color: Color(0xFF5E35B1)),
];
