import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  final PlaybackController _playback = PlaybackController.instance;

  @override
  void initState() {
    super.initState();
    _playback.init();
  }

  Future<void> _createPlaylistFromQueue() async {
    if (_playback.queue.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Queue is empty. Play something first.')),
      );
      return;
    }

    final now = DateTime.now();
    final TextEditingController ctrl = TextEditingController(
      text: 'My Playlist ${now.hour}:${now.minute.toString().padLeft(2, '0')}',
    );

    final String? name = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Create Playlist'),
          content: TextField(
            controller: ctrl,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Playlist name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (name == null || name.trim().isEmpty) return;
    await _playback.createPlaylistFromQueue(name.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved "$name"')),
    );
  }

  Future<void> _playPlaylist(Playlist playlist) async {
    await _playback.playPlaylist(playlist.id);
    if (!mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const NowPlayingScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _playback,
        builder: (_, __) {
          final playlists = _playback.playlists;
          return Stack(
            children: [
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Playlists',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: _createPlaylistFromQueue,
                            icon: const Icon(Icons.library_add_rounded, size: 18),
                            label: const Text('Save Queue'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'MVP: create playlists from the current queue and replay them anytime.',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_playback.scanError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _playback.scanError!,
                          style: GoogleFonts.manrope(color: const Color(0xFFFF9AA6), fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: playlists.isEmpty
                          ? _EmptyPlaylists(onCreate: _createPlaylistFromQueue)
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 170),
                              itemCount: playlists.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final playlist = playlists[i];
                                final tracks = _playback.tracksForPlaylist(playlist.id);
                                return _PlaylistCard(
                                  playlist: playlist,
                                  trackCount: tracks.length,
                                  onPlay: () => _playPlaylist(playlist),
                                  onDelete: () => _playback.deletePlaylist(playlist.id),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final int trackCount;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  const _PlaylistCard({
    required this.playlist,
    required this.trackCount,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.70),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.30),
                  AppColors.primary.withValues(alpha: 0.10),
                ],
              ),
            ),
            child: const Icon(Icons.queue_music_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  '$trackCount tracks',
                  style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.onSurfaceVariant,
            tooltip: 'Delete playlist',
          ),
          FilledButton.tonalIcon(
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Play'),
          ),
        ],
      ),
    );
  }
}

class _EmptyPlaylists extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyPlaylists({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.surfaceContainer,
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.playlist_add_rounded, size: 42, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                'No playlists yet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Play songs from your library, then save your current queue as a playlist.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.library_add_rounded),
                label: const Text('Create from Queue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
