import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/music_models.dart';
import '../services/export_service.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    final PlaybackController playback = PlaybackController.instance;

    return AnimatedBuilder(
      animation: playback,
      builder: (context, _) {
        final Playlist? playlist = playback.playlists.cast<Playlist?>().firstWhere(
          (p) => p?.id == playlistId,
          orElse: () => null,
        );

        if (playlist == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.of(context).pop();
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final tracks = playback.tracksForPlaylist(playlistId);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Positioned(
                top: -60,
                right: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.14),
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
                    // top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                            color: AppColors.onSurface,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              playlist.name,
                              style: GoogleFonts.epilogue(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.onSurface,
                                letterSpacing: -0.4,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showRenameDialog(context, playback, playlist),
                            icon: const Icon(Icons.drive_file_rename_outline_rounded, size: 22),
                            color: AppColors.primary,
                            tooltip: 'Rename',
                          ),
                          IconButton(
                            onPressed: () => _showShareSheet(context, playlist, tracks),
                            icon: const Icon(Icons.ios_share_rounded, size: 22),
                            color: AppColors.primary,
                            tooltip: 'Export / share',
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(context, playback, playlist),
                            icon: const Icon(Icons.delete_outline_rounded, size: 22),
                            color: AppColors.onSurfaceVariant,
                            tooltip: 'Delete playlist',
                          ),
                        ],
                      ),
                    ),
                    // meta row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      child: Row(
                        children: [
                          Text(
                            '${tracks.length} tracks',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          if (tracks.isNotEmpty)
                            FilledButton.icon(
                              onPressed: () => _playAndNavigate(context, playback, playlistId),
                              icon: const Icon(Icons.play_arrow_rounded, size: 18),
                              label: const Text('Play All'),
                            ),
                        ],
                      ),
                    ),
                    // track list
                    Expanded(
                      child: tracks.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.music_off_rounded,
                                      size: 56, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No tracks found on this device',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ReorderableListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 160),
                              physics: const BouncingScrollPhysics(),
                              onReorder: (oldIndex, newIndex) =>
                                  playback.reorderPlaylistTrack(playlistId, oldIndex, newIndex),
                              itemCount: tracks.length,
                              itemBuilder: (_, i) {
                                final track = tracks[i];
                                final isPlaying = playback.currentTrack?.id == track.id && playback.isPlaying;
                                return _PlaylistTrackRow(
                                  key: ValueKey(track.id),
                                  track: track,
                                  isPlaying: isPlaying,
                                  onTap: () async {
                                    await playback.playPlaylist(playlistId, startIndex: i);
                                    if (!context.mounted) return;
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => const NowPlayingScreen(),
                                        transitionsBuilder: (_, anim, __, child) => SlideTransition(
                                          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                                              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  onRemove: () => playback.removeTrackFromPlaylist(playlistId, track.id),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _playAndNavigate(BuildContext context, PlaybackController playback, String id) async {
    await playback.playPlaylist(id);
    if (!context.mounted) return;
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const NowPlayingScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  void _showShareSheet(BuildContext context, Playlist playlist, List<Track> tracks) {
    final export = ExportService.instance;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ExportSheet(
        playlist: playlist,
        tracks: tracks,
        export: export,
      ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, PlaybackController playback, Playlist playlist) async {
    final ctrl = TextEditingController(text: playlist.name);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Playlist'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Playlist name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text('Save')),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    await playback.renamePlaylist(playlist.id, name.trim());
  }

  Future<void> _confirmDelete(BuildContext context, PlaybackController playback, Playlist playlist) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Delete "${playlist.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF9AA6)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await playback.deletePlaylist(playlist.id);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

class _PlaylistTrackRow extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _PlaylistTrackRow({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isPlaying
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
        border: isPlaying ? Border.all(color: AppColors.primary.withValues(alpha: 0.4)) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.surfaceContainerHigh,
          ),
          child: Icon(
            isPlaying ? Icons.equalizer_rounded : Icons.music_note_rounded,
            size: 20,
            color: isPlaying ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
        title: Text(
          track.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: isPlaying ? AppColors.primary : AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          track.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
              color: AppColors.onSurfaceVariant,
              tooltip: 'Remove from playlist',
              onPressed: onRemove,
            ),
            const Icon(Icons.drag_handle_rounded, size: 20, color: AppColors.outlineVariant),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// ─── Export / share bottom sheet ──────────────────────────────────────────────

class _ExportSheet extends StatelessWidget {
  final Playlist playlist;
  final List<Track> tracks;
  final ExportService export;

  const _ExportSheet({
    required this.playlist,
    required this.tracks,
    required this.export,
  });

  void _copy(BuildContext context, String content, String label) {
    Clipboard.setData(ClipboardData(text: content));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.ios_share_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Export "${playlist.name}"',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${tracks.length} tracks',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(indent: 20, endIndent: 20),
          _ExportOption(
            icon: Icons.format_list_bulleted_rounded,
            label: 'Copy as Track List',
            subtitle: 'Numbered text list — paste anywhere',
            onTap: () => _copy(
              context,
              export.trackList(playlist, tracks),
              'Track list',
            ),
          ),
          _ExportOption(
            icon: Icons.queue_music_rounded,
            label: 'Copy as M3U',
            subtitle: 'Works with VLC, foobar2000, and most players',
            onTap: () => _copy(
              context,
              export.toM3U(playlist, tracks),
              'M3U playlist',
            ),
          ),
          _ExportOption(
            icon: Icons.table_chart_rounded,
            label: 'Copy as CSV',
            subtitle: 'Open in spreadsheets (Excel, Sheets)',
            onTap: () => _copy(
              context,
              export.toCSV(playlist, tracks),
              'CSV playlist',
            ),
          ),
          _ExportOption(
            icon: Icons.data_object_rounded,
            label: 'Copy as JSON',
            subtitle: 'Full metadata export with file paths',
            onTap: () => _copy(
              context,
              export.toJSON(playlist, tracks),
              'JSON playlist',
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.manrope(
          fontSize: 11,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: const Icon(Icons.copy_rounded,
          size: 16, color: AppColors.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
