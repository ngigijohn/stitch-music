import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class AlbumSpotlightScreen extends StatelessWidget {
  const AlbumSpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaybackController playback = PlaybackController.instance;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Album Spotlight',
          style: GoogleFonts.epilogue(fontWeight: FontWeight.w800),
        ),
      ),
      body: AnimatedBuilder(
        animation: playback,
        builder: (context, _) {
          final List<Track> tracks = playback.library.take(5).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C4DFF), Color(0xFF1F1234)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Velvet Clouds',
                      style: GoogleFonts.epilogue(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Luminous Theory',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tracks.isEmpty
                          ? 'Scan your device library to explore and play from a real album sequence.'
                          : 'Using the current device library as the playable album queue for this spotlight surface.',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: tracks.isEmpty
                          ? null
                          : () async {
                              await playback.playFromLibrary(tracks.first, sourceList: tracks);
                              if (!context.mounted) return;
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                              );
                            },
                      icon: const Icon(Icons.play_circle_fill_rounded),
                      label: Text(tracks.isEmpty ? 'Library Required' : 'Play Album Queue'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              ...tracks.map((track) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    tileColor: AppColors.surfaceContainerLow,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: track.dominantColor.withValues(alpha: 0.2),
                      ),
                      child: Icon(Icons.album_rounded, color: track.dominantColor),
                    ),
                    title: Text(track.title),
                    subtitle: Text('${track.artist} • ${track.duration}'),
                    trailing: const Icon(Icons.play_arrow_rounded),
                    onTap: () async {
                      await playback.playFromLibrary(track, sourceList: tracks);
                      if (!context.mounted) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}