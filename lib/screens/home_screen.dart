import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../services/streaming/online_search_activity_service.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';
import 'online_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaybackController _playback = PlaybackController.instance;
  final OnlineSearchActivityService _searchActivity = OnlineSearchActivityService.instance;

  @override
  void initState() {
    super.initState();
    _playback.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_playback, _searchActivity]),
      builder: (context, _) {
        final favoriteTracks = _playback.library
            .where((track) => _playback.isFavorite(track.id))
            .take(8)
            .toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              _AmbientBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _TopAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 160),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 8),
                        _HeroSection(playback: _playback),
                        const SizedBox(height: 28),
                        const _OnlineDiscoverySection(),
                        const SizedBox(height: 34),
                        _RecentPlaysSection(playback: _playback),
                        const SizedBox(height: 34),
                        _FavoriteTracksSection(
                          playback: _playback,
                          favorites: favoriteTracks,
                        ),
                        const SizedBox(height: 34),
                        _RecentOnlineSearchesSection(activity: _searchActivity),
                        const SizedBox(height: 40),
                        _DailyMixesSection(),
                        const SizedBox(height: 40),
                        _NewReleasesSection(),
                      ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OnlineDiscoverySection extends StatelessWidget {
  const _OnlineDiscoverySection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF111827), Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.primary.withValues(alpha: 0.18),
                  ),
                  child: const Icon(Icons.cloud_queue_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Online Discovery',
                        style: GoogleFonts.epilogue(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore the YouTube search experience in demo mode while official API integration stays fail-closed.',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusChip(label: 'Demo Results'),
                _StatusChip(label: 'Entitlement Banners'),
                _StatusChip(label: 'Policy-Compliant'),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OnlineSearchScreen()),
                    );
                  },
                  icon: const Icon(Icons.travel_explore_rounded, size: 18),
                  label: const Text('Open Online Search'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No playback is enabled here yet.',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

// ─── Ambient glow background ─────────────────────────────────────────────────
class _AmbientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: -80,
        left: -60,
        child: Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColors.primary.withValues(alpha: 0.18),
              Colors.transparent,
            ]),
          ),
        ),
      ),
      Positioned(
        bottom: 200,
        right: -80,
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              const Color(0xFF7C4DFF).withValues(alpha: 0.20),
              Colors.transparent,
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ─── Top App Bar ─────────────────────────────────────────────────────────────
class _TopAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: false,
      floating: true,
      toolbarHeight: 72,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColors.primary, size: 26),
            const Spacer(),
            Text(
              'The Sonic Gallery',
              style: GoogleFonts.epilogue(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerHigh,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.person_rounded, size: 20, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final PlaybackController playback;

  const _HeroSection({required this.playback});

  @override
  Widget build(BuildContext context) {
    final currentTrack = playback.currentTrack;
    final title = currentTrack?.title ?? 'Start Your Session';
    final subtitle = currentTrack?.artist ?? 'Play from your library and your current track will live here.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _openNowPlaying(context),
        child: Container(
          height: 252,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A1A44), Color(0xFF1A0A2E), Color(0xFF120B1A)],
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color(0xFF7C4DFF).withValues(alpha: 0.35),
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.12),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 68, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.surface.withValues(alpha: 0.88)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTrack == null ? 'READY TO PLAY' : 'NOW PLAYING',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.epilogue(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                          height: 0.98,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () => _openNowPlaying(context),
                            icon: Icon(
                              playback.isPlaying ? Icons.equalizer_rounded : Icons.play_arrow_rounded,
                              size: 20,
                            ),
                            label: Text(currentTrack == null ? 'Open Player' : 'Resume'),
                          ),
                          const SizedBox(width: 12),
                          _GlassCircleButton(
                            icon: Icons.cloud_queue_rounded,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const OnlineSearchScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openNowPlaying(BuildContext ctx) {
    Navigator.of(ctx).push(PageRouteBuilder(
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
}

// ─── Recent Plays ─────────────────────────────────────────────────────────────
class _RecentPlaysSection extends StatelessWidget {
  final PlaybackController playback;

  const _RecentPlaysSection({required this.playback});

  @override
  Widget build(BuildContext context) {
    final recents = playback.recents.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Plays',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: recents.isEmpty
              ? const _EmptyInfoCard(
                  title: 'No recent local plays',
                  subtitle: 'Play something from your library and it will show up here.',
                  icon: Icons.history_rounded,
                )
              : _AsymmetricGrid(recents: recents, playback: playback),
        ),
      ],
    );
  }
}

class _AsymmetricGrid extends StatelessWidget {
  final List<Track> recents;
  final PlaybackController playback;

  const _AsymmetricGrid({required this.recents, required this.playback});

  @override
  Widget build(BuildContext context) {
    final primary = recents.first;
    final secondary = recents.length > 1 ? recents[1] : null;
    final tertiary = recents.length > 2 ? recents[2] : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _LargeRecentCard(track: primary, playback: playback),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              if (secondary != null)
                _SmallRecentCard(track: secondary, playback: playback)
              else
                const _CompactEmptyRecentCard(),
              const SizedBox(height: 12),
              if (tertiary != null)
                _SmallRecentCard(track: tertiary, playback: playback)
              else
                const _CompactEmptyRecentCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeRecentCard extends StatelessWidget {
  final Track track;
  final PlaybackController playback;

  const _LargeRecentCard({required this.track, required this.playback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => playback.playFromLibrary(track, sourceList: playback.library),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              track.dominantColor.withValues(alpha: 0.52),
              const Color(0xFF251040),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.history_toggle_off_rounded, color: AppColors.primary.withValues(alpha: 0.7), size: 36),
            const Spacer(),
            Text(
              track.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              '${track.artist} • ${track.duration}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallRecentCard extends StatelessWidget {
  final Track track;
  final PlaybackController playback;

  const _SmallRecentCard({required this.track, required this.playback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => playback.playFromLibrary(track, sourceList: playback.library),
      child: Container(
        height: 94,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF120B20),
          border: Border.all(color: track.dominantColor.withValues(alpha: 0.25)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    track.dominantColor.withValues(alpha: 0.6),
                    track.dominantColor.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: const Icon(Icons.music_note_rounded, size: 22, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              track.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              track.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactEmptyRecentCard extends StatelessWidget {
  const _CompactEmptyRecentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surfaceContainerLow,
      ),
      child: Center(
        child: Text(
          'Play more',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _FavoriteTracksSection extends StatelessWidget {
  final PlaybackController playback;
  final List<Track> favorites;

  const _FavoriteTracksSection({required this.playback, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Favorite Tracks',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (favorites.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _EmptyInfoCard(
              title: 'No favorites yet',
              subtitle: 'Tap the heart on Now Playing to keep your top tracks here.',
              icon: Icons.favorite_border_rounded,
            ),
          )
        else
          SizedBox(
            height: 198,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _FavoriteTrackCard(track: favorites[i], playback: playback),
            ),
          ),
      ],
    );
  }
}

class _FavoriteTrackCard extends StatelessWidget {
  final Track track;
  final PlaybackController playback;

  const _FavoriteTrackCard({required this.track, required this.playback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => playback.playFromLibrary(track, sourceList: playback.library),
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.75),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    track.dominantColor.withValues(alpha: 0.75),
                    track.dominantColor.withValues(alpha: 0.28),
                  ],
                ),
              ),
              child: const Icon(Icons.favorite_rounded, color: AppColors.primary),
            ),
            const Spacer(),
            Text(
              track.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              track.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentOnlineSearchesSection extends StatelessWidget {
  final OnlineSearchActivityService activity;

  const _RecentOnlineSearchesSection({required this.activity});

  @override
  Widget build(BuildContext context) {
    final searches = activity.recentSearches.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Online Searches',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 14),
        if (searches.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _EmptyInfoCard(
              title: 'No online searches yet',
              subtitle: 'Run a search in Online Discovery and it will show up here.',
              icon: Icons.cloud_queue_rounded,
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: searches.map((entry) => _RecentSearchRow(entry: entry)).toList(),
            ),
          ),
      ],
    );
  }
}

class _RecentSearchRow extends StatelessWidget {
  final OnlineSearchActivity entry;

  const _RecentSearchRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.surfaceContainerLow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.travel_explore_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.query,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.resultCount} results • ${entry.demoMode ? 'Demo mode' : 'Safe mode'}',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            entry.provider.toUpperCase(),
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _EmptyInfoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.66),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Daily Mixes ─────────────────────────────────────────────────────────────
class _DailyMixesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                'Daily Mixes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800, letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See All',
                  style: GoogleFonts.manrope(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: kDailyMixes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (ctx, i) => _MixCard(mix: kDailyMixes[i]),
          ),
        ),
      ],
    );
  }
}

class _MixCard extends StatelessWidget {
  final Mix mix;
  const _MixCard({required this.mix});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Art
          Container(
            width: 180,
            height: 155,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  mix.color.withValues(alpha: 0.9),
                  mix.color.withValues(alpha: 0.4),
                  AppColors.surfaceContainerLow,
                ],
              ),
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.music_note_rounded, size: 56, color: AppColors.primary.withValues(alpha: 0.6))),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: AppColors.onPrimary, size: 22),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mix.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            mix.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── New Releases ─────────────────────────────────────────────────────────────
class _NewReleasesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'New Releases',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800, letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Featured release (large bento)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: AppColors.surfaceContainerHigh,
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Album art placeholder
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C4DFF), Color(0xFF4C1D95)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.album_rounded, color: AppColors.primary, size: 48),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          'Album of the Week',
                          style: GoogleFonts.manrope(
                            fontSize: 9, fontWeight: FontWeight.w800,
                            color: AppColors.tertiary, letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Velvet Clouds',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900, letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Luminous Theory',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary, fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryDim,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          textStyle: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Explore Album'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Small track tiles
        ...kLibraryTracks.take(3).map((t) => _NewReleaseRow(track: t)),
      ],
    );
  }
}

class _NewReleaseRow extends StatelessWidget {
  final Track track;
  const _NewReleaseRow({required this.track});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surfaceContainerLow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: track.dominantColor.withValues(alpha: 0.3),
              ),
              child: Icon(Icons.music_note_rounded, color: track.dominantColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(track.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text(track.artist, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.play_circle_rounded, color: AppColors.onSurfaceVariant, size: 28),
          ],
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceContainerHighest.withValues(alpha: 0.60),
        ),
        child: Icon(icon, color: AppColors.onSurface, size: 22),
      ),
    );
  }
}
