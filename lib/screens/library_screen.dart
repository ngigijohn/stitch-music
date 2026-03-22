import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stitch_music/l10n/app_localizations.dart';

import '../models/music_models.dart';
import '../services/cache_service.dart';
import '../services/playback_controller.dart';
import 'cache_settings_screen.dart';
import 'online_search_screen.dart';
import '../theme/app_theme.dart';
import '../screens/now_playing_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final PlaybackController _playback = PlaybackController.instance;
  final CacheService _cache = CacheService.instance;

  String _query = '';
  int _selectedChip = 0;

  @override
  void initState() {
    super.initState();
    _playback.init();
  }

  List<Track> _filtered(List<Track> tracks) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return tracks;
    return tracks.where((t) {
      return t.title.toLowerCase().contains(q) ||
          t.artist.toLowerCase().contains(q) ||
          t.album.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = [
      l10n.libraryFilterAll,
      l10n.libraryFilterSongs,
      l10n.libraryFilterAlbums,
      l10n.libraryFilterArtists,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: Listenable.merge([_playback, _cache]),
        builder: (context, _) {
          final List<Track> songs = _filtered(_playback.library);
          return Stack(
            children: [
              Positioned(
                top: 0,
                right: -60,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.10),
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
                              l10n.libraryTitle,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),
                          if (_cache.isOfflineMode)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFFF6B35)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.wifi_off_rounded,
                                    size: 12,
                                    color: Color(0xFFFF6B35),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Offline',
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFF6B35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          IconButton(
                            onPressed: _playback.scanDeviceLibrary,
                            icon: const Icon(Icons.refresh_rounded),
                            color: AppColors.primary,
                            tooltip: l10n.libraryRescanTooltip,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const CacheSettingsScreen()),
                              );
                            },
                            icon: const Icon(
                                Icons.download_for_offline_rounded),
                            color: AppColors.primary,
                            tooltip: 'Offline & cache settings',
                          ),
                          IconButton(
                            onPressed: _cache.isOfflineMode
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const OnlineSearchScreen()),
                                    );
                                  },
                            icon: Icon(
                              Icons.cloud_queue_rounded,
                              color: _cache.isOfflineMode
                                  ? AppColors.onSurfaceVariant
                                      .withValues(alpha: 0.35)
                                  : AppColors.primary,
                            ),
                            tooltip: l10n.libraryOnlineSearchTooltip,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: _cache.isOfflineMode
                              ? AppColors.surfaceContainerHigh.withValues(alpha: 0.40)
                              : AppColors.surfaceContainerHigh.withValues(alpha: 0.72),
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.45)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primary.withValues(alpha: 0.16),
                              ),
                              child: const Icon(Icons.cloud_queue_rounded, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.libraryOnlineSearchTitle,
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.libraryOnlineSearchDescription,
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FilledButton.tonalIcon(
                              onPressed: _cache.isOfflineMode
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const OnlineSearchScreen()),
                                      );
                                    },
                              icon: Icon(
                                _cache.isOfflineMode
                                    ? Icons.wifi_off_rounded
                                    : Icons.open_in_new_rounded,
                                size: 18,
                              ),
                              label: Text(_cache.isOfflineMode ? 'Offline' : l10n.openLabel),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        style: GoogleFonts.manrope(color: AppColors.onSurface, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: l10n.librarySearchHint,
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant, size: 20),
                          suffixIcon: _query.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchCtrl.clear();
                                    setState(() => _query = '');
                                  },
                                  child: const Icon(Icons.close_rounded, color: AppColors.onSurfaceVariant, size: 18),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final selected = _selectedChip == i;
                          return FilterChip(
                            label: Text(filters[i]),
                            selected: selected,
                            onSelected: (_) => setState(() => _selectedChip = i),
                            labelStyle: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                            ),
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            showCheckmark: false,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DiagnosticsPanel(playback: _playback, songCount: songs.length),
                    const SizedBox(height: 10),
                    if (_playback.isScanning)
                      const LinearProgressIndicator(minHeight: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Text(
                        l10n.songsCount(songs.length),
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: songs.isEmpty
                          ? _EmptyState(
                              isScanning: _playback.isScanning,
                              onScan: _playback.scanDeviceLibrary,
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 160),
                              physics: const BouncingScrollPhysics(),
                              itemCount: songs.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 4),
                              itemBuilder: (_, i) => _TrackRow(
                                track: songs[i],
                                isPlaying: _playback.currentTrack?.id == songs[i].id && _playback.isPlaying,
                                isPinned: _cache.isPinned(songs[i].id),
                                onTogglePin: () => _cache.togglePin(songs[i].id),
                                onTap: () async {
                                  await _playback.playFromLibrary(songs[i], sourceList: songs);
                                  if (!context.mounted) return;
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
                                },
                              ),
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

class _DiagnosticsPanel extends StatelessWidget {
  final PlaybackController playback;
  final int songCount;

  const _DiagnosticsPanel({required this.playback, required this.songCount});

  static const _green = Color(0xFF8FE388);
  static const _red   = Color(0xFFFF9AA6);
  static const _amber = Color(0xFFFFC86B);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final status   = playback.permissionStatus;
    final granted  = status == PermissionStatus.granted ||
                     status == PermissionStatus.limited;
    final permaDenied = status == PermissionStatus.permanentlyDenied;
    final error    = playback.scanError;
    final DateTime? last = playback.lastScanAt;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- permission status row ---
            Row(
              children: [
                Icon(
                  granted
                      ? Icons.check_circle_rounded
                      : permaDenied
                          ? Icons.block_rounded
                          : Icons.warning_amber_rounded,
                  size: 16,
                  color: granted ? _green : permaDenied ? _red : _amber,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    granted
                      ? l10n.mediaAccessGranted
                        : permaDenied
                        ? l10n.permissionPermanentlyDenied
                        : l10n.mediaPermissionRequired,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: granted ? _green : permaDenied ? _red : _amber,
                    ),
                  ),
                ),
                Text(
                  playback.isScanning ? l10n.scanningStatus : l10n.idleStatus,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // --- metrics ---
            Text(
              l10n.songsDetectedCount(songCount),
              style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              l10n.lastScan(last == null ? l10n.neverLabel : _fmtTime(last)),
              style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
            // --- scan error with retry ---
            if (error != null && !playback.isScanning) ...
              [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: _red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        error,
                        style: GoogleFonts.manrope(fontSize: 11, color: _red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: playback.scanDeviceLibrary,
                      child: Text(
                        l10n.retryLabel,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            // --- permission actions ---
            if (!granted) ...
              [
                const SizedBox(height: 10),
                if (permaDenied)
                  _ActionButton(
                    icon: Icons.settings_rounded,
                    label: l10n.openAppSettings,
                    onTap: openAppSettings,
                  )
                else
                  _ActionButton(
                    icon: Icons.lock_open_rounded,
                    label: l10n.grantMusicPermission,
                    onTap: playback.scanDeviceLibrary,
                  ),
              ],
          ],
        ),
      ),
    );
  }

  static String _fmtTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} $h:$m';
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final bool isPinned;
  final VoidCallback onTogglePin;
  final VoidCallback onTap;

  const _TrackRow({
    required this.track,
    required this.isPlaying,
    required this.isPinned,
    required this.onTogglePin,
    required this.onTap,
  });

  void _showTrackMenu(BuildContext context) {
    final PlaybackController playback = PlaybackController.instance;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AnimatedBuilder(
        animation: playback,
        builder: (ctx, __) {
          final playlists = playback.playlists;
          return Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.epilogue(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        track.artist,
                        style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(indent: 20, endIndent: 20),
                if (playlists.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No playlists yet. Create one from the Playlists tab.',
                      style: GoogleFonts.manrope(fontSize: 13, color: AppColors.onSurfaceVariant),
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                    child: Text(
                      'ADD TO PLAYLIST',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlists.length,
                      itemBuilder: (_, i) {
                        final pl = playlists[i];
                        final alreadyIn = pl.trackIds.contains(track.id);
                        return ListTile(
                          leading: Icon(
                            alreadyIn ? Icons.check_circle_rounded : Icons.playlist_add_rounded,
                            color: alreadyIn ? AppColors.primary : AppColors.onSurfaceVariant,
                            size: 22,
                          ),
                          title: Text(
                            pl.name,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: alreadyIn ? AppColors.primary : AppColors.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            '${pl.trackIds.length} tracks',
                            style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                          onTap: alreadyIn
                              ? null
                              : () async {
                                  await playback.addTrackToPlaylist(pl.id, track.id);
                                  if (!ctx.mounted) return;
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Added to "${pl.name}"')),
                                  );
                                },
                        );
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showTrackMenu(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isPlaying ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceContainerLow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    track.dominantColor.withValues(alpha: 0.7),
                    track.dominantColor.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: Icon(
                isPlaying ? Icons.graphic_eq_rounded : Icons.music_note_rounded,
                color: AppColors.onSurface.withValues(alpha: 0.9),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isPlaying ? AppColors.primary : null,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${track.artist} • ${track.album}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              track.duration,
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onTogglePin,
              child: Icon(
                isPinned ? Icons.download_done_rounded : Icons.download_for_offline_outlined,
                size: 18,
                color: isPinned ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _showTrackMenu(context),
              child: const Icon(Icons.more_vert_rounded, color: AppColors.onSurfaceVariant, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScan;

  const _EmptyState({required this.isScanning, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.library_music_rounded, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'No songs found on this device yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: isScanning ? null : onScan,
              icon: const Icon(Icons.sync_rounded),
              label: const Text('Scan Device Music'),
            ),
          ],
        ),
      ),
    );
  }
}
