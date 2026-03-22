import '../models/music_models.dart';

/// Pure-logic export service — converts playlists/tracks to portable text
/// formats. Returns [String] so callers can copy to clipboard or write to
/// a file. All methods are synchronous and dependency-free.
class ExportService {
  ExportService._();
  static final ExportService instance = ExportService._();

  // ── M3U ──────────────────────────────────────────────────────────────────────

  /// Generates an extended M3U playlist file content.
  /// Compatible with VLC, foobar2000, and most media players.
  String toM3U(Playlist playlist, List<Track> tracks) {
    final buf = StringBuffer();
    buf.writeln('#EXTM3U');
    buf.writeln('# Stitch Music playlist export');
    buf.writeln('# Playlist: ${playlist.name}');
    buf.writeln('# Exported: ${DateTime.now().toIso8601String()}');
    buf.writeln();
    for (final track in tracks) {
      final durationSec = track.durationMs > 0 ? track.durationMs ~/ 1000 : -1;
      buf.writeln('#EXTINF:$durationSec,${track.artist} - ${track.title}');
      if (track.filePath != null && track.filePath!.isNotEmpty) {
        buf.writeln(track.filePath);
      } else if (track.uri != null && track.uri!.isNotEmpty) {
        buf.writeln(track.uri);
      } else {
        // Fallback: a comment so the file remains valid
        buf.writeln('# (no path available for this track)');
      }
    }
    return buf.toString();
  }

  // ── CSV ───────────────────────────────────────────────────────────────────────

  /// Generates a CSV export of all tracks in the playlist.
  /// Columns: #, Title, Artist, Album, Duration, Path
  String toCSV(Playlist playlist, List<Track> tracks) {
    final buf = StringBuffer();
    // header
    buf.writeln('"#","Title","Artist","Album","Duration","Path"');
    for (var i = 0; i < tracks.length; i++) {
      final t = tracks[i];
      buf.writeln([
        i + 1,
        _csvCell(t.title),
        _csvCell(t.artist),
        _csvCell(t.album),
        _csvCell(t.duration),
        _csvCell(t.filePath ?? t.uri ?? ''),
      ].join(','));
    }
    return buf.toString();
  }

  // ── JSON ──────────────────────────────────────────────────────────────────────

  /// Generates a human-readable JSON export.
  String toJSON(Playlist playlist, List<Track> tracks) {
    final buf = StringBuffer();
    buf.writeln('{');
    buf.writeln('  "stitch_music_export": true,');
    buf.writeln('  "exported_at": "${DateTime.now().toIso8601String()}",');
    buf.writeln('  "playlist": {');
    buf.writeln('    "id": "${playlist.id}",');
    buf.writeln('    "name": ${_jsonStr(playlist.name)},');
    buf.writeln('    "track_count": ${tracks.length},');
    buf.writeln('    "tracks": [');
    for (var i = 0; i < tracks.length; i++) {
      final t = tracks[i];
      final last = i == tracks.length - 1;
      buf.writeln('      {');
      buf.writeln('        "index": $i,');
      buf.writeln('        "id": "${t.id}",');
      buf.writeln('        "title": ${_jsonStr(t.title)},');
      buf.writeln('        "artist": ${_jsonStr(t.artist)},');
      buf.writeln('        "album": ${_jsonStr(t.album)},');
      buf.writeln('        "duration": "${t.duration}",');
      buf.writeln('        "duration_ms": ${t.durationMs},');
      buf.writeln('        "path": ${_jsonStr(t.filePath ?? t.uri ?? '')}');
      buf.writeln('      }${last ? '' : ','}');
    }
    buf.writeln('    ]');
    buf.writeln('  }');
    buf.writeln('}');
    return buf.toString();
  }

  // ── Track text card ────────────────────────────────────────────────────────

  /// Short human-readable text for sharing a single track.
  /// e.g. "🎵 Blinding Lights\nThe Weeknd • After Hours\n[3:22]"
  String trackCard(Track track) =>
      '🎵 ${track.title}\n${track.artist} • ${track.album}\n[${track.duration}]';

  /// Compact inline format: "Artist - Title (Duration)"
  String trackInline(Track track) =>
      '${track.artist} - ${track.title} (${track.duration})';

  // ── Plain track list ───────────────────────────────────────────────────────

  /// A numbered plain-text track listing for a playlist.
  String trackList(Playlist playlist, List<Track> tracks) {
    final buf = StringBuffer();
    buf.writeln('${playlist.name} — ${tracks.length} tracks');
    buf.writeln();
    for (var i = 0; i < tracks.length; i++) {
      final t = tracks[i];
      buf.writeln('${(i + 1).toString().padLeft(2)}. ${t.artist} - ${t.title}  [${t.duration}]');
    }
    return buf.toString();
  }

  // ── Internal helpers ──────────────────────────────────────────────────────

  String _csvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  String _jsonStr(String value) {
    final escaped = value
        .replaceAll(r'\', r'\\')
        .replaceAll('"', r'\"')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', '');
    return '"$escaped"';
  }
}
