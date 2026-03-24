import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';

/// Profile screen with dynamic stats from PlaybackController.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: PlaybackController.instance,
          builder: (context, _) {
            final playback = PlaybackController.instance;
            final int songCount = playback.library.length;
            final int artistCount = playback.library.map((t) => t.artist).toSet().length;
            final int hoursEstimate =
                playback.library.fold<int>(0, (sum, t) => sum + t.durationMs) ~/ 3600000;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
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
                            'Music Lover',
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
                  // Stats row with dynamic data
                  Row(
                    children: [
                      _StatCard(label: 'Songs', value: _fmt(songCount)),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Artists', value: _fmt(artistCount)),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Hours', value: _fmt(hoursEstimate)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Menu items
                  ...[
                    ('Edit Profile', Icons.edit_rounded),
                    ('Listening History', Icons.history_rounded),
                    ('Downloads', Icons.download_rounded),
                    ('Settings', Icons.settings_rounded),
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
                        onTap: () {},
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static String _fmt(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
    }
    return '$n';
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
