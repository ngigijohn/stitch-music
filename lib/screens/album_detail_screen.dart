import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';
import 'artist_detail_screen.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({super.key, required this.album});

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

  void _openArtist(BuildContext ctx) {
    Navigator.of(ctx).push(PageRouteBuilder(
      pageBuilder: (_, a1, a2) => ArtistDetailScreen(artist: kVesperArtist),
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
    await PlaybackController.instance.playFromLibrary(track, sourceList: album.tracks);
    if (!ctx.mounted) return;
    _openNowPlaying(ctx);
  }

  Future<void> _playAlbum(BuildContext ctx) async {
    if (album.tracks.isEmpty) return;
    await PlaybackController.instance.playFromLibrary(album.tracks.first, sourceList: album.tracks);
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
            top: -100,
            right: -80,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  album.dominantColor.withValues(alpha: 0.22),
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
                    _buildAlbumHeader(context),
                    const SizedBox(height: 32),
                    _buildActions(context),
                    const SizedBox(height: 32),
                    _buildTracklist(context),
                    const SizedBox(height: 32),
                    _buildMetadata(context),
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

  Widget _buildAlbumHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album art
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
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
                    color: album.dominantColor.withValues(alpha: 0.35),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Icon(Icons.album_rounded, size: 80, color: AppColors.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            album.title,
            style: GoogleFonts.epilogue(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _openArtist(context),
            child: Text(
              album.artist,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${album.year} · ${album.tracks.length} tracks',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          // Play button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _playAlbum(context),
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: const Text('Play Album'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.favorite_border_rounded,
            label: 'Favourite',
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.share_rounded,
            label: 'Share',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTracklist(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                'Tracklist',
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${album.tracks.length}',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...album.tracks.asMap().entries.map((e) => _TrackItem(
              index: e.key + 1,
              track: e.value,
              onTap: () => _playTrack(context, e.value),
            )),
      ],
    );
  }

  Widget _buildMetadata(BuildContext context) {
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
              'Album Info',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _MetaRow(label: 'Released', value: album.year),
            const SizedBox(height: 10),
            _MetaRow(label: 'Genre', value: album.genre),
            const SizedBox(height: 10),
            _MetaRow(label: 'Artist', value: album.artist),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
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

class _TrackItem extends StatelessWidget {
  final int index;
  final Track track;
  final VoidCallback onTap;

  const _TrackItem({required this.index, required this.track, required this.onTap});

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
              width: 28,
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
            const SizedBox(width: 12),
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
                    track.artist,
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
            Icon(Icons.favorite_border_rounded, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Icon(Icons.more_vert_rounded, size: 18, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
