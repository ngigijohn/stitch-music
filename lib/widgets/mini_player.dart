import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../screens/now_playing_screen.dart';
import '../services/playback_controller.dart';

/// Floating glassmorphic "pill" mini-player that sits above the nav bar.
class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final PlaybackController _playback = PlaybackController.instance;

  void _openNowPlaying() {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, a1, a2) => const NowPlayingScreen(),
      transitionsBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _playback,
      builder: (_, __) {
        final track = _playback.currentTrack;
        if (track == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: _openNowPlaying,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: AppColors.glassPanel,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.40),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C4DFF), Color(0xFF4C1D96)],
                        ),
                      ),
                      child: const Icon(Icons.music_note_rounded, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            track.title,
                            style: GoogleFonts.epilogue(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${track.artist.toUpperCase()} • ${_playback.isPlaying ? 'PLAYING' : 'PAUSED'}',
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _playback.skipPrevious,
                          icon: const Icon(Icons.skip_previous_rounded),
                          color: AppColors.onSurfaceVariant,
                          iconSize: 22,
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                        ),
                        GestureDetector(
                          onTap: _playback.togglePlayPause,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: Icon(
                              _playback.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: AppColors.onPrimary,
                              size: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _playback.skipNext,
                          icon: const Icon(Icons.skip_next_rounded),
                          color: AppColors.onSurfaceVariant,
                          iconSize: 22,
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
