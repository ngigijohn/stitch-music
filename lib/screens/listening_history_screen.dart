import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/analytics_service.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class ListeningHistoryScreen extends StatelessWidget {
  const ListeningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaybackController playback = PlaybackController.instance;
    final AnalyticsService analytics = AnalyticsService.instance;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Listening History',
          style: GoogleFonts.epilogue(fontWeight: FontWeight.w800),
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([playback, analytics]),
        builder: (context, _) {
          final recents = playback.recents;
          final topTracks = analytics.topTracks(limit: 5);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _HistorySummaryCard(
                recentCount: recents.length,
                totalPlays: analytics.totalPlays,
                listened: analytics.totalListenedFormatted,
              ),
              const SizedBox(height: 24),
              Text('Recent tracks', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (recents.isEmpty)
                _emptyCard('Play something to populate your history.')
              else
                ...recents.map((track) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      tileColor: AppColors.surfaceContainerLow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      title: Text(track.title),
                      subtitle: Text('${track.artist} • ${track.album}'),
                      trailing: Text(track.duration),
                      onTap: () async {
                        await playback.playFromLibrary(track, sourceList: playback.library);
                        if (!context.mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
                        );
                      },
                    ),
                  );
                }),
              const SizedBox(height: 24),
              Text('Top plays', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (topTracks.isEmpty)
                _emptyCard('Analytics will surface top plays after a few sessions.')
              else
                ...topTracks.map((track) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      tileColor: AppColors.surfaceContainerLow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      leading: const Icon(Icons.insights_rounded, color: AppColors.primary),
                      title: Text(track.title),
                      subtitle: Text('${track.artist} • ${track.plays} plays'),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.surfaceContainerLow,
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}

class _HistorySummaryCard extends StatelessWidget {
  final int recentCount;
  final int totalPlays;
  final String listened;

  const _HistorySummaryCard({
    required this.recentCount,
    required this.totalPlays,
    required this.listened,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.surfaceContainerHigh,
      ),
      child: Row(
        children: [
          _stat('Recent', '$recentCount'),
          const SizedBox(width: 12),
          _stat('Plays', '$totalPlays'),
          const SizedBox(width: 12),
          _stat('Listened', listened.isEmpty ? '0m' : listened),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.epilogue(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}