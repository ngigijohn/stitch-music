import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stitch_music/l10n/app_localizations.dart';
import '../services/analytics_service.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'cache_settings_screen.dart';
import 'listening_history_screen.dart';
import 'profile_edit_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final PlaybackController playback = PlaybackController.instance;
    final AnalyticsService analytics = AnalyticsService.instance;

    return AnimatedBuilder(
      animation: Listenable.merge([playback, analytics]),
      builder: (context, _) {
        final libraryCount = playback.library.length;
        final artistCount = playback.library.map((track) => track.artist).toSet().length;
        final listened = analytics.totalListenedFormatted.isEmpty ? '0m' : analytics.totalListenedFormatted;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.profileTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 32),
              // Avatar row
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.8),
                          const Color(0xFF7C4DFF),
                        ],
                      ),
                    ),
                    child: const Icon(Icons.person_rounded, size: 42, color: AppColors.onPrimary),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profileDisplayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'listener@stitchmusic.app',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Stats row
              Row(
                children: [
                  _StatCard(label: l10n.profileSongs, value: '$libraryCount'),
                  const SizedBox(width: 12),
                  _StatCard(label: l10n.profileArtists, value: '$artistCount'),
                  const SizedBox(width: 12),
                  _StatCard(label: l10n.profileHours, value: listened),
                ],
              ),
              const SizedBox(height: 32),
              // Menu items
              ...[
                (
                  l10n.profileEdit,
                  Icons.edit_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileEditScreen())),
                ),
                (
                  l10n.profileHistory,
                  Icons.history_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListeningHistoryScreen())),
                ),
                (
                  l10n.profileDownloads,
                  Icons.download_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CacheSettingsScreen())),
                ),
                (
                  l10n.profileSettings,
                  Icons.settings_rounded,
                  () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                ),
              ].map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.surfaceContainerLow,
                  ),
                  child: ListTile(
                    leading: Icon(item.$2, color: AppColors.primary, size: 22),
                    title: Text(
                      item.$1,
                      style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
                    onTap: item.$3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              }),
            ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surfaceContainerHigh,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
