import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'artist_detail_screen.dart';
import 'now_playing_screen.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumTitle;
  final String artist;
  final Color dominantColor;
  final List<Track> tracks;

  const AlbumDetailScreen({
    super.key,
    required this.albumTitle,
    required this.artist,
    required this.dominantColor,
    required this.tracks,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final PlaybackController _playback = PlaybackController.instance;
  final Set<String> _favorites = {};

  String get _totalDuration {
    int totalMs = 0;
    for (final t in widget.tracks) {
      totalMs += t.durationMs;
    }
    final int mins = totalMs ~/ 60000;
    return '$mins min';
  }

  void _playAlbum() {
    if (widget.tracks.isEmpty) return;
    _playback.playFromLibrary(widget.tracks.first, sourceList: widget.tracks);
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, a1, a2) => const NowPlayingScreen(),
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ));
  }

  void _playTrack(Track track) {
    _playback.playFromLibrary(track, sourceList: widget.tracks);
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, a1, a2) => const NowPlayingScreen(),
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
    ));
  }

  void _openArtist() {
    final artistTracks = _playback.library.isNotEmpty
        ? _playback.library.where((t) => t.artist == widget.artist).toList()
        : widget.tracks;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ArtistDetailScreen(
        artistName: widget.artist,
        dominantColor: widget.dominantColor,
        tracks: artistTracks.isNotEmpty ? artistTracks : widget.tracks,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Color headerColor = widget.dominantColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Header ─────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.background,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.onSurface,
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
                color: AppColors.onSurface,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.blurBackground, StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          headerColor.withValues(alpha: 0.80),
                          headerColor.withValues(alpha: 0.40),
                          AppColors.background,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  // Album art placeholder
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      margin: const EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            headerColor.withValues(alpha: 0.9),
                            headerColor.withValues(alpha: 0.5),
                            const Color(0xFF1A0B2E),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: headerColor.withValues(alpha: 0.4),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.album_rounded, size: 80, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Album Info ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Album • 2024',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.albumTitle,
                    style: GoogleFonts.epilogue(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _openArtist,
                    child: Text(
                      widget.artist,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Play & Favorite row
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _playAlbum,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Play Album'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerHigh,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border_rounded, color: AppColors.onSurfaceVariant),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerHigh,
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_rounded, color: AppColors.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Tracklist header
                  Row(
                    children: [
                      Text(
                        'Tracklist',
                        style: GoogleFonts.epilogue(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.tracks.length} Tracks • $_totalDuration',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ─── Track List ───────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final track = widget.tracks[i];
                final isFav = _favorites.contains(track.id);
                return AnimatedBuilder(
                  animation: _playback,
                  builder: (_, __) {
                    final playing = _playback.currentTrack?.id == track.id;
                    return _TrackRow(
                      index: i + 1,
                      track: track,
                      isPlaying: playing,
                      isFavorite: isFav,
                      onTap: () => _playTrack(track),
                      onFavorite: () => setState(() {
                        if (_favorites.contains(track.id)) {
                          _favorites.remove(track.id);
                        } else {
                          _favorites.add(track.id);
                        }
                      }),
                    );
                  },
                );
              },
              childCount: widget.tracks.length,
            ),
          ),

          // ─── Album Metadata ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.surfaceContainerLow,
                ),
                child: Column(
                  children: [
                    _MetaRow(label: 'Released', value: 'October 2024'),
                    const SizedBox(height: 12),
                    _MetaRow(label: 'Genre', value: 'Electronic, Synthwave'),
                    const SizedBox(height: 12),
                    _MetaRow(label: 'Label', value: 'Synthetic Records'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Track Row ──────────────────────────────────────────────────────────────
class _TrackRow extends StatelessWidget {
  final int index;
  final Track track;
  final bool isPlaying;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _TrackRow({
    required this.index,
    required this.track,
    required this.isPlaying,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: isPlaying
                  ? const _EqualizerIcon()
                  : Text(
                      '$index',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? AppColors.primary : AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
            IconButton(
              onPressed: onFavorite,
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 18,
                color: isFavorite ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            Text(
              track.duration,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.more_horiz_rounded, color: AppColors.onSurfaceVariant, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── Equalizer Animation ───────────────────────────────────────────────────
class _EqualizerIcon extends StatefulWidget {
  const _EqualizerIcon();

  @override
  State<_EqualizerIcon> createState() => _EqualizerIconState();
}

class _EqualizerIconState extends State<_EqualizerIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _Bar(height: 6 + _ctrl.value * 10),
            const SizedBox(width: 2),
            _Bar(height: 12 + (1 - _ctrl.value) * 4),
            const SizedBox(width: 2),
            _Bar(height: 4 + _ctrl.value * 8),
          ],
        );
      },
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  const _Bar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ─── Metadata Row ──────────────────────────────────────────────────────────
class _MetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
