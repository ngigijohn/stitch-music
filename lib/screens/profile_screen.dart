import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stitch_music/l10n/app_localizations.dart';
import '../services/analytics_service.dart';
import '../services/playback_controller.dart';
import '../services/profile_preferences_service.dart';
import '../theme/app_theme.dart';
import 'cache_settings_screen.dart';
import 'insights_screen.dart';
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
    final ProfilePreferencesService profile = ProfilePreferencesService.instance;
    profile.init();

    return AnimatedBuilder(
      animation: Listenable.merge([playback, analytics, profile]),
      builder: (context, _) {
        final libraryCount = playback.library.length;
        final artistCount = playback.library.map((track) => track.artist).toSet().length;
        final listened = analytics.totalListenedFormatted.isEmpty ? '0m' : analytics.totalListenedFormatted;
        final topArtist = analytics.topArtists(limit: 1).isEmpty ? 'No activity yet' : analytics.topArtists(limit: 1).first.artist;
        final totalPlays = analytics.totalPlays;
        final favoriteCount = playback.favorites.length;
        final recentTrack = playback.recents.isEmpty ? null : playback.recents.first;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.displayName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email,
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recentTrack == null ? 'Ready to build your listening profile.' : 'Recently played: ${recentTrack.title}',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      _StatCard(label: l10n.profileSongs, value: '$libraryCount'),
                      const SizedBox(width: 12),
                      _StatCard(label: l10n.profileArtists, value: '$artistCount'),
                      const SizedBox(width: 12),
                      _StatCard(label: l10n.profileHours, value: listened),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionLabel(label: 'Listening Snapshot'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _SummaryCard(label: 'Top Artist', value: topArtist),
                      const SizedBox(width: 12),
                      _SummaryCard(label: 'Total Plays', value: '$totalPlays'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _SummaryCard(label: 'Favorites', value: '$favoriteCount'),
                      const SizedBox(width: 12),
                      _SummaryCard(label: 'Recent Track', value: recentTrack?.title ?? 'None'),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionLabel(label: 'Quick Access'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAccessCard(
                          icon: Icons.bar_chart_rounded,
                          title: 'Insights',
                          subtitle: 'Open listening stats',
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InsightsScreen())),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAccessCard(
                          icon: Icons.history_rounded,
                          title: 'History',
                          subtitle: 'Recent plays and trends',
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListeningHistoryScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAccessCard(
                          icon: Icons.download_rounded,
                          title: 'Offline',
                          subtitle: 'Pins and cache settings',
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CacheSettingsScreen())),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAccessCard(
                          icon: Icons.settings_rounded,
                          title: 'Settings',
                          subtitle: 'Open app preferences',
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SectionLabel(label: 'Profile Tools'),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 140),
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

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.epilogue(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surfaceContainerHigh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surfaceContainerLow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: AppColors.onSurface)),
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
