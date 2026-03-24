import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/music_models.dart';
import 'album_detail_screen.dart';
import 'artist_detail_screen.dart';
import 'now_playing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Ambient background blobs
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
                    _HeroSection(),
                    const SizedBox(height: 40),
                    _RecentPlaysSection(),
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
  }
}

// ─── Shared album navigation helper ──────────────────────────────────────────
void _pushAlbum(BuildContext ctx, Album album) {
  Navigator.of(ctx).push(PageRouteBuilder(
    pageBuilder: (_, a1, a2) => AlbumDetailScreen(album: album),
    transitionsBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      );
    },
  ));
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _openNowPlaying(context),
        child: Container(
          height: 240,
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
              // Colour wash
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
              // Content
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.surface.withValues(alpha: 0.85)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NOW TRENDING',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Midnight\nEuphoria',
                        style: GoogleFonts.epilogue(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: AppColors.onSurface,
                          height: 0.95,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () => _openNowPlaying(context),
                            icon: const Icon(Icons.play_arrow_rounded, size: 20),
                            label: const Text('Listen Now'),
                          ),
                          const SizedBox(width: 12),
                          _GlassCircleButton(
                            icon: Icons.album_rounded,
                            onTap: () => _openAlbum(context),
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

  void _openAlbum(BuildContext ctx) => _pushAlbum(ctx, kNeonHorizonAlbum);
}

// ─── Recent Plays ─────────────────────────────────────────────────────────────
class _RecentPlaysSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Plays',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800, letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _AsymmetricGrid(),
        ),
      ],
    );
  }
}

class _AsymmetricGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large card
        Expanded(
          flex: 2,
          child: _LargeRecentCard(
            title: 'Late Night Sessions',
            subtitle: 'Playlist • 48 tracks',
            color: const Color(0xFF251040),
          ),
        ),
        const SizedBox(width: 12),
        // Two small artist cards stacked
        Expanded(
          child: Column(
            children: [
              _SmallArtistCard(name: 'Solaris', role: 'Artist', color: const Color(0xFF1A0A36)),
              const SizedBox(height: 12),
              _SmallArtistCard(name: 'Echoes', role: 'Artist', color: const Color(0xFF0D0820)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LargeRecentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _LargeRecentCard({required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: color,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF7C4DFF).withValues(alpha: 0.4),
            color,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.queue_music_rounded, color: AppColors.primary.withValues(alpha: 0.7), size: 36),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _SmallArtistCard extends StatelessWidget {
  final String name;
  final String role;
  final Color color;

  const _SmallArtistCard({required this.name, required this.role, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
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
              color: AppColors.surfaceContainerHighest,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.5),
                  const Color(0xFF7C4DFF).withValues(alpha: 0.3),
                ],
              ),
            ),
            child: const Icon(Icons.person_rounded, size: 22, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(name, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800)),
          Text(role, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
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
                        onPressed: () => _pushAlbum(context, kNeonHorizonAlbum),
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
    return GestureDetector(
      onTap: () => _pushAlbum(context, kNeonHorizonAlbum),
      child: Padding(
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
