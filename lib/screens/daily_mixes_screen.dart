import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class DailyMixesScreen extends StatelessWidget {
  final String? selectedMixId;

  const DailyMixesScreen({super.key, this.selectedMixId});

  @override
  Widget build(BuildContext context) {
    final PlaybackController playback = PlaybackController.instance;
    final Mix selectedMix = kDailyMixes.firstWhere(
      (mix) => mix.id == selectedMixId,
      orElse: () => kDailyMixes.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Daily Mixes',
          style: GoogleFonts.epilogue(fontWeight: FontWeight.w800),
        ),
      ),
      body: AnimatedBuilder(
        animation: playback,
        builder: (context, _) {
          final library = playback.library;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            children: [
              _MixHeroCard(
                mix: selectedMix,
                trackCount: library.length,
                onPlay: library.isEmpty
                    ? null
                    : () async {
                        await playback.playFromLibrary(
                          library.first,
                          sourceList: library,
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NowPlayingScreen(),
                          ),
                        );
                      },
              ),
              const SizedBox(height: 24),
              ...kDailyMixes.map((mix) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MixListTile(
                    mix: mix,
                    selected: mix.id == selectedMix.id,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => DailyMixesScreen(selectedMixId: mix.id),
                        ),
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

class _MixHeroCard extends StatelessWidget {
  final Mix mix;
  final int trackCount;
  final VoidCallback? onPlay;

  const _MixHeroCard({
    required this.mix,
    required this.trackCount,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mix.color.withValues(alpha: 0.82),
            AppColors.surfaceContainerHigh,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mix.title,
            style: GoogleFonts.epilogue(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mix.description,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            trackCount == 0
                ? 'Scan your library to start this mix.'
                : '$trackCount local tracks are ready for playback.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(trackCount == 0 ? 'Library Required' : 'Play From Library'),
          ),
        ],
      ),
    );
  }
}

class _MixListTile extends StatelessWidget {
  final Mix mix;
  final bool selected;
  final VoidCallback onTap;

  const _MixListTile({
    required this.mix,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: AppColors.surfaceContainerLow,
          border: selected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.4))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: mix.color.withValues(alpha: 0.22),
              ),
              child: Icon(Icons.auto_awesome_rounded, color: mix.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mix.title,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mix.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}