import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stitch_music/l10n/app_localizations.dart';

import '../services/analytics_service.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final AnalyticsService _analytics = AnalyticsService.instance;
  final PlaybackController _playback = PlaybackController.instance;

  @override
  void initState() {
    super.initState();
    _analytics.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _analytics.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _pct(double v) => '${(v * 100).round()}%';

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
        child: Text(
          title,
          style: GoogleFonts.epilogue(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
          ),
        ),
      );

  // ── Stat chips row ─────────────────────────────────────────────────────────

  Widget _statChip({
    required IconData icon,
    required String value,
    required String label,
    Color? iconColor,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 10,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Builder(builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Row(
            children: [
              _statChip(
                icon: Icons.play_circle_outline_rounded,
                value: '${_analytics.totalPlays}',
                label: l10n.insightsTotalPlays,
              ),
              _statChip(
                icon: Icons.access_time_rounded,
                value: _analytics.totalListenedFormatted.isEmpty
                    ? '0m'
                    : _analytics.totalListenedFormatted,
                label: l10n.insightsListened,
                iconColor: AppColors.secondary,
              ),
              _statChip(
                icon: Icons.library_music_rounded,
                value: '${_playback.library.length}',
                label: l10n.insightsInLibrary,
                iconColor: const Color(0xFF26A69A),
              ),
              _statChip(
                icon: Icons.favorite_rounded,
                value: '${_playback.favorites.length}',
                label: l10n.insightsFavorites,
                iconColor: const Color(0xFFEF5350),
              ),
            ],
          );
        }),
      );

  // ── Skip rate badge ────────────────────────────────────────────────────────

  Widget _skipRateBadge() {
    final rate = _analytics.skipRate;
    final color = rate < 0.3
        ? const Color(0xFF26A69A)
        : rate < 0.6
            ? AppColors.secondary
            : const Color(0xFFEF5350);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.skip_next_rounded, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.insightsSkipRate,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    _analytics.totalPlays == 0
                        ? AppLocalizations.of(context)!.insightsSkipRateNoData
                        : rate < 0.3
                            ? AppLocalizations.of(context)!.insightsSkipRateLow
                            : rate < 0.6
                                ? AppLocalizations.of(context)!.insightsSkipRateModerate
                                : AppLocalizations.of(context)!.insightsSkipRateHigh,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _pct(rate),
              style: GoogleFonts.epilogue(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Weekly bar chart ───────────────────────────────────────────────────────

  Widget _weeklyChart() {
    final activity = _analytics.weeklyActivity;
    final maxVal = math.max(activity.max, 1);
    final days = [
      AppLocalizations.of(context)!.insightsDayMon,
      AppLocalizations.of(context)!.insightsDayTue,
      AppLocalizations.of(context)!.insightsDayWed,
      AppLocalizations.of(context)!.insightsDayThu,
      AppLocalizations.of(context)!.insightsDayFri,
      AppLocalizations.of(context)!.insightsDaySat,
      AppLocalizations.of(context)!.insightsDaySun,
    ];
    // Align playsByDay (0=oldest) to Mon–Sun by using today's weekday
    final todayWd = DateTime.now().weekday; // 1=Mon, 7=Sun
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.insightsLast7Days,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (i) {
                  final count = activity.playsByDay[i];
                  final heightFraction = count / maxVal;
                  // Which day label does index i correspond to?
                  // index 6 = today, so dayIndexInWeek = (todayWd - 1 - (6-i) + 7) % 7
                  final dayIndex = ((todayWd - 1) - (6 - i) + 7) % 7;
                  final isToday = i == 6;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (count > 0)
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$count',
                                style: GoogleFonts.manrope(
                                  fontSize: 8,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            height: math.max(heightFraction * 60, 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isToday
                                    ? [AppColors.primary, AppColors.primaryContainer]
                                    : [
                                        AppColors.primary.withValues(alpha: 0.35),
                                        AppColors.primary.withValues(alpha: 0.6),
                                      ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            days[dayIndex],
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: isToday
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isToday
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top tracks list ────────────────────────────────────────────────────────

  Widget _topTracksSection() {
    final tracks = _analytics.topTracks(limit: 5);
    if (tracks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _emptyCard(AppLocalizations.of(context)!.insightsNoTopTracks),
      );
    }
    final maxPlays = tracks.first.plays;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(tracks.length, (i) {
          final t = tracks[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RankedBar(
              rank: i + 1,
              label: t.title,
              sublabel: t.artist,
              value: t.plays,
              maxValue: maxPlays,
              unit: t.plays == 1 ? AppLocalizations.of(context)!.insightsPlaySingular : AppLocalizations.of(context)!.insightsPlayPlural,
              accent: AppColors.primary,
            ),
          );
        }),
      ),
    );
  }

  // ── Top artists list ───────────────────────────────────────────────────────

  Widget _topArtistsSection() {
    final artists = _analytics.topArtists(limit: 5);
    if (artists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _emptyCard(AppLocalizations.of(context)!.insightsNoTopArtists),
      );
    }
    final maxPlays = artists.first.plays;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(artists.length, (i) {
          final a = artists[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RankedBar(
              rank: i + 1,
              label: a.artist,
              sublabel: AppLocalizations.of(context)!.insightsMinPlayed(a.totalSecondsPlayed ~/ 60),
              value: a.plays,
              maxValue: maxPlays,
              unit: a.plays == 1 ? AppLocalizations.of(context)!.insightsPlaySingular : AppLocalizations.of(context)!.insightsPlayPlural,
              accent: AppColors.secondary,
            ),
          );
        }),
      ),
    );
  }

  Widget _emptyCard(String message) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.bar_chart_rounded,
                color: AppColors.onSurfaceVariant, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );

  // ── Clear data button ──────────────────────────────────────────────────────

  Widget _clearButton() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: OutlinedButton.icon(
          onPressed: _showClearDialog,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF5350),
            side: const BorderSide(color: Color(0xFFEF5350), width: 1),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          label: Text(
            AppLocalizations.of(context)!.insightsClearStats,
            style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
          ),
        ),
      );

  void _showClearDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHighest,
        title: Text(
          AppLocalizations.of(context)!.insightsClearTitle,
          style: GoogleFonts.epilogue(
              fontWeight: FontWeight.w700, color: AppColors.onSurface),
        ),
        content: Text(
          AppLocalizations.of(context)!.insightsClearContent,
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.insightsCancelButton,
                style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              _analytics.clearAll();
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.insightsClearButton,
              style: GoogleFonts.manrope(
                  color: const Color(0xFFEF5350),
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppLocalizations.of(context)!.insightsTitle,
                style: GoogleFonts.epilogue(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 16),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _summaryRow(),
                _sectionHeader(AppLocalizations.of(context)!.insightsListeningHabits),
                _skipRateBadge(),
                const SizedBox(height: 16),
                _weeklyChart(),
                _sectionHeader(AppLocalizations.of(context)!.insightsTopTracks),
                _topTracksSection(),
                _sectionHeader(AppLocalizations.of(context)!.insightsTopArtists),
                _topArtistsSection(),
                _clearButton(),
                // Extra padding for mini-player + nav bar
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable ranked bar widget ───────────────────────────────────────────────

class _RankedBar extends StatelessWidget {
  final int rank;
  final String label;
  final String sublabel;
  final int value;
  final int maxValue;
  final String unit;
  final Color accent;

  const _RankedBar({
    required this.rank,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.maxValue,
    required this.unit,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = maxValue > 0 ? value / maxValue : 0.0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Rank badge
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: GoogleFonts.epilogue(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: rank == 1 ? accent : AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Track info + bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  sublabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                LayoutBuilder(
                  builder: (context, constraints) => Stack(
                    children: [
                      Container(
                        height: 4,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        height: 4,
                        width: constraints.maxWidth * fraction,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accent.withValues(alpha: 0.7), accent],
                          ),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Count
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$value',
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                unit,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
