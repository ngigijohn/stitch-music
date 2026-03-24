import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'album_detail_screen.dart';
import 'now_playing_screen.dart';

class ArtistDetailScreen extends StatelessWidget {
  final Artist artist;

  const ArtistDetailScreen({super.key, required this.artist});

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

  void _openAlbum(BuildContext ctx, Album album) {
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

  Future<void> _playTrack(BuildContext ctx, Track track) async {
    await PlaybackController.instance
        .playFromLibrary(track, sourceList: artist.topTracks);
    if (!ctx.mounted) return;
    _openNowPlaying(ctx);
  }

  Future<void> _playArtist(BuildContext ctx) async {
    if (artist.topTracks.isEmpty) return;
    await PlaybackController.instance
        .playFromLibrary(artist.topTracks.first, sourceList: artist.topTracks);
    if (!ctx.mounted) return;
    _openNowPlaying(ctx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient glow
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  artist.dominantColor.withValues(alpha: 0.20),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 80),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHero(context),
                    const SizedBox(height: 32),
                    _buildTopTracks(context),
                    const SizedBox(height: 32),
                    _buildAlbums(context),
                    const SizedBox(height: 32),
                    _buildAbout(context),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        color: AppColors.onSurface,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          color: AppColors.onSurface,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(36),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              artist.dominantColor.withValues(alpha: 0.55),
              AppColors.surfaceContainerHighest,
              AppColors.surfaceContainer,
            ],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Colour overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.background.withValues(alpha: 0.80),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    artist.name,
                    style: GoogleFonts.epilogue(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                      height: 0.95,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${artist.monthlyListeners} monthly listeners',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Follow button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Follow',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Play circle button
                      GestureDetector(
                        onTap: () => _playArtist(context),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: AppColors.onPrimary,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTracks(BuildContext context) {
    final tracks = artist.topTracks.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                'Top Tracks',
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'See All',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...tracks.asMap().entries.map((e) => _TopTrackRow(
              index: e.key + 1,
              track: e.value,
              onTap: () => _playTrack(context, e.value),
            )),
      ],
    );
  }

  Widget _buildAlbums(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Albums & EPs',
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            itemCount: artist.albums.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (ctx, i) => _AlbumCard(
              album: artist.albums[i],
              onTap: () => _openAlbum(context, artist.albums[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAbout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: GoogleFonts.epilogue(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              artist.bio,
              style: GoogleFonts.manrope(
                fontSize: 14,
                height: 1.6,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopTrackRow extends StatelessWidget {
  final int index;
  final Track track;
  final VoidCallback onTap;

  const _TopTrackRow({required this.index, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$index',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    track.dominantColor.withValues(alpha: 0.7),
                    track.dominantColor.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: const Icon(Icons.music_note_rounded, color: AppColors.onSurface, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.album,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              track.duration,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.more_vert_rounded, size: 18, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _AlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const _AlbumCard({required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 148,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 148,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    album.dominantColor,
                    album.dominantColor.withValues(alpha: 0.5),
                    AppColors.surfaceContainerHighest,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: album.dominantColor.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.album_rounded,
                size: 48,
                color: AppColors.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              album.title,
              style: GoogleFonts.epilogue(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              album.year,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
