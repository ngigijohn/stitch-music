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

// ─── Album & Artist models ────────────────────────────────────────────────────

class Album {
  final String id;
  final String title;
  final String artist;
  final String year;
  final String genre;
  final Color dominantColor;
  final List<Track> tracks;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.year,
    required this.genre,
    required this.dominantColor,
    required this.tracks,
  });
}

class Artist {
  final String id;
  final String name;
  final String monthlyListeners;
  final String bio;
  final Color dominantColor;
  final List<Album> albums;
  final List<Track> topTracks;

  const Artist({
    required this.id,
    required this.name,
    required this.monthlyListeners,
    required this.bio,
    required this.dominantColor,
    required this.albums,
    required this.topTracks,
  });
}

// ─── Sample album/artist data ─────────────────────────────────────────────────

const List<Track> kNeonHorizonTracks = [
  Track(id: 'nh1', title: 'Midnight Transmission', artist: 'Vesper', album: 'Neon Horizon', duration: '4:22', dominantColor: Color(0xFF7C4DFF)),
  Track(id: 'nh2', title: 'Prism Dreams', artist: 'Vesper', album: 'Neon Horizon', duration: '3:58', dominantColor: Color(0xFF9C5CFF)),
  Track(id: 'nh3', title: 'Static in the Rain', artist: 'Vesper', album: 'Neon Horizon', duration: '5:12', dominantColor: Color(0xFF6A3FC8)),
  Track(id: 'nh4', title: 'Binary Sunset', artist: 'Vesper', album: 'Neon Horizon', duration: '4:05', dominantColor: Color(0xFF7C4DFF)),
  Track(id: 'nh5', title: 'Cybernetic Heartbeat', artist: 'Vesper', album: 'Neon Horizon', duration: '3:47', dominantColor: Color(0xFF8B5CF6)),
];

const List<Track> kStardustEchoesTracks = [
  Track(id: 'se1', title: 'Stardust Prelude', artist: 'Vesper', album: 'Stardust Echoes', duration: '3:30', dominantColor: Color(0xFF5E35B1)),
  Track(id: 'se2', title: 'Void Walker', artist: 'Vesper', album: 'Stardust Echoes', duration: '4:10', dominantColor: Color(0xFF4C6EF5)),
  Track(id: 'se3', title: 'Neon Cathedral', artist: 'Vesper', album: 'Stardust Echoes', duration: '5:22', dominantColor: Color(0xFF7C4DFF)),
];

// Albums use final (not const) because the track lists are mutable List<Track>,
// not compile-time const lists, so the Album constructor cannot be evaluated at compile time.
final Album kNeonHorizonAlbum = Album(
  id: 'a1',
  title: 'Neon Horizon',
  artist: 'Vesper',
  year: '2024',
  genre: 'Synthwave, Dream-pop',
  dominantColor: const Color(0xFF7C4DFF),
  tracks: kNeonHorizonTracks,
);

final Album kStardustEchoesAlbum = Album(
  id: 'a2',
  title: 'Stardust Echoes',
  artist: 'Vesper',
  year: '2023',
  genre: 'Ambient Electronic',
  dominantColor: const Color(0xFF5E35B1),
  tracks: kStardustEchoesTracks,
);

final Artist kVesperArtist = Artist(
  id: 'ar1',
  name: 'Vesper',
  monthlyListeners: '3.4M',
  bio: 'Emerging from the neon-lit streets of Berlin, Vesper has redefined the boundaries of atmospheric electronic music. Known for blending brutalist synth-lines with delicate, ethereal vocals, their soundscapes invite listeners into a cinematic world of sound.',
  dominantColor: const Color(0xFF7C4DFF),
  albums: [kNeonHorizonAlbum, kStardustEchoesAlbum],
  topTracks: [
    Track(id: 'nh2', title: 'Prism Dreams', artist: 'Vesper', album: 'Neon Horizon', duration: '3:58', dominantColor: Color(0xFF9C5CFF)),
    Track(id: 'nh1', title: 'Midnight Transmission', artist: 'Vesper', album: 'Neon Horizon', duration: '4:22', dominantColor: Color(0xFF7C4DFF)),
    Track(id: 'se3', title: 'Neon Cathedral', artist: 'Vesper', album: 'Stardust Echoes', duration: '5:22', dominantColor: Color(0xFF6A3FC8)),
  ],
);
