import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'album_detail_screen.dart';
import 'now_playing_screen.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String artistName;
  final Color dominantColor;
  final List<Track> tracks;

  const ArtistDetailScreen({
    super.key,
    required this.artistName,
    required this.dominantColor,
    required this.tracks,
  });

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final PlaybackController _playback = PlaybackController.instance;
  bool _isFollowing = false;

  List<Track> get _topTracks => widget.tracks.take(5).toList();

  /// Group tracks into unique albums, returning a list of (albumTitle, tracks).
  List<MapEntry<String, List<Track>>> get _albums {
    final Map<String, List<Track>> map = {};
    for (final track in widget.tracks) {
      map.putIfAbsent(track.album, () => []).add(track);
    }
    return map.entries.toList();
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

  static String _formatListeners(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }

  void _openAlbum(String albumTitle, List<Track> albumTracks) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => AlbumDetailScreen(
        albumTitle: albumTitle,
        artist: widget.artistName,
        dominantColor: widget.dominantColor,
        tracks: albumTracks,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Hero Header ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topCenter,
                        radius: 1.2,
                        colors: [
                          widget.dominantColor.withValues(alpha: 0.60),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                  // Artist avatar placeholder
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      margin: const EdgeInsets.only(bottom: 48),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            widget.dominantColor,
                            widget.dominantColor.withValues(alpha: 0.5),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.dominantColor.withValues(alpha: 0.4),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person_rounded, size: 72, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Artist Info ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.artistName,
                    style: GoogleFonts.epilogue(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_formatListeners(widget.tracks.length * 1247)} Monthly Listeners',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Follow & Play row
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => setState(() => _isFollowing = !_isFollowing),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _isFollowing ? AppColors.onPrimary : AppColors.primary,
                          backgroundColor: _isFollowing ? AppColors.primary : Colors.transparent,
                          side: BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        ),
                        child: Text(
                          _isFollowing ? 'Following' : 'Follow',
                          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryContainer],
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (widget.tracks.isNotEmpty) _playTrack(widget.tracks.first);
                          },
                          icon: const Icon(Icons.play_arrow_rounded, color: AppColors.onPrimary),
                          iconSize: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ─── Top Tracks ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    'Top Tracks',
                    style: GoogleFonts.epilogue(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See All',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final track = _topTracks[i];
                return AnimatedBuilder(
                  animation: _playback,
                  builder: (_, __) {
                    final isPlaying = _playback.currentTrack?.id == track.id;
                    return _TopTrackRow(
                      rank: i + 1,
                      track: track,
                      isPlaying: isPlaying,
                      onTap: () => _playTrack(track),
                    );
                  },
                );
              },
              childCount: _topTracks.length,
            ),
          ),

          // ─── Albums & EPs ─────────────────────────────────────────────
          if (_albums.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Text(
                  'Albums & EPs',
                  style: GoogleFonts.epilogue(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 180,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _albums.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, i) {
                    final entry = _albums[i];
                    return _AlbumCard(
                      title: entry.key,
                      subtitle: entry.value.length == 1 ? 'Single' : 'Album',
                      color: widget.dominantColor.withValues(alpha: 0.6 + i * 0.1),
                      onTap: () => _openAlbum(entry.key, entry.value),
                    );
                  },
                ),
              ),
            ),
          ],

          // ─── About ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: GoogleFonts.epilogue(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.surfaceContainerLow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'An emerging force in electronic music, ${widget.artistName} blends atmospheric synth-lines with modern production to create immersive sonic worlds. Their sound invites listeners on a cinematic journey through soundscapes that push the boundaries of what music can be.',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                'Read More',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Track Row ────────────────────────────────────────────────────────
class _TopTrackRow extends StatelessWidget {
  final int rank;
  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;

  const _TopTrackRow({
    required this.rank,
    required this.track,
    required this.isPlaying,
    required this.onTap,
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
              width: 24,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: track.dominantColor.withValues(alpha: 0.3),
              ),
              child: Icon(Icons.music_note_rounded, color: track.dominantColor, size: 24),
            ),
            const SizedBox(width: 14),
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
                    track.duration,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_horiz_rounded, color: AppColors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Album Card ───────────────────────────────────────────────────────────
class _AlbumCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AlbumCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.4)],
                ),
              ),
              child: const Icon(Icons.album_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
    );
  }
}
