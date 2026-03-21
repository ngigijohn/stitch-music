import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final PlaybackController _playback = PlaybackController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _playback,
      builder: (_, __) {
        final List<Track> queue = _playback.queue;
        final Track? current = _playback.currentTrack;

        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (ctx, scrollCtrl) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Text(
                          'Up Next',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: AppColors.surfaceContainerHigh,
                          ),
                          child: Text(
                            '${queue.length} songs',
                            style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded),
                          color: AppColors.onSurfaceVariant,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (current != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: _NowPlayingHighlight(track: current),
                    ),
                  Expanded(
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      physics: const BouncingScrollPhysics(),
                      scrollController: scrollCtrl,
                      onReorder: _playback.reorderQueue,
                      itemCount: queue.length,
                      itemBuilder: (_, i) {
                        final track = queue[i];
                        return _QueueTrackRow(
                          key: ValueKey(track.id),
                          track: track,
                          isPlaying: i == _playback.currentIndex,
                          onTap: () => _playback.playAtIndex(i),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _NowPlayingHighlight extends StatelessWidget {
  final Track track;
  const _NowPlayingHighlight({required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.surfaceContainerHigh,
          ],
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [track.dominantColor, track.dominantColor.withValues(alpha: 0.4)],
              ),
            ),
            child: const Icon(Icons.music_note_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Now Playing', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 2)),
                const SizedBox(height: 2),
                Text(track.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(track.artist, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.graphic_eq_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _QueueTrackRow extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;

  const _QueueTrackRow({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isPlaying ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.drag_indicator_rounded, color: AppColors.outlineVariant, size: 20),
            const SizedBox(width: 8),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: track.dominantColor.withValues(alpha: 0.25),
              ),
              child: Icon(
                Icons.music_note_rounded,
                color: isPlaying ? AppColors.primary : AppColors.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isPlaying ? AppColors.primary : AppColors.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(track.artist, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Text(track.duration, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant)),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert_rounded, color: AppColors.outlineVariant, size: 18),
          ],
        ),
      ),
    );
  }
}
