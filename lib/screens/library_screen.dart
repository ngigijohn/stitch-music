import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/music_models.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'now_playing_screen.dart';
import 'playlists_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final PlaybackController _playback = PlaybackController.instance;

  String _query = '';
  int _selectedChip = 0;

  static const List<String> _filters = ['All', 'Songs', 'Albums', 'Artists'];

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _playback,
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
                              'Your Library',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _playback.scanDeviceLibrary,
                            icon: const Icon(Icons.refresh_rounded),
                            color: AppColors.primary,
                            tooltip: 'Rescan device',
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, a1, a2) =>
                                    const PlaylistsScreen(),
                                transitionsBuilder: (_, anim, __, child) =>
                                    SlideTransition(
                                  position: Tween(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero)
                                      .animate(CurvedAnimation(
                                          parent: anim,
                                          curve: Curves.easeOutCubic)),
                                  child: child,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.queue_music_rounded),
                            color: AppColors.onSurfaceVariant,
                            tooltip: 'Playlists',
                          ),
                        ],
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
                          hintText: 'Search songs, artists, albums...',
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
                        itemCount: _filters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (ctx, i) {
                          final selected = _selectedChip == i;
                          return FilterChip(
                            label: Text(_filters[i]),
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
                    if (_playback.scanError != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        child: Text(
                          _playback.scanError!,
                          style: GoogleFonts.manrope(color: const Color(0xFFFF9AA6), fontSize: 12),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Text(
                        '${songs.length} songs',
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

  @override
  Widget build(BuildContext context) {
    final permission = playback.permissionStatus;
    final bool granted = permission == PermissionStatus.granted;
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
            Row(
              children: [
                Icon(
                  granted ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                  size: 16,
                  color: granted ? const Color(0xFF8FE388) : const Color(0xFFFF9AA6),
                ),
                const SizedBox(width: 6),
                Text(
                  granted ? 'Media access granted' : 'Media access required',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: granted ? const Color(0xFF8FE388) : const Color(0xFFFF9AA6),
                  ),
                ),
                const Spacer(),
                Text(
                  playback.isScanning ? 'Scanning...' : 'Idle',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Songs detected: $songCount',
              style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              'Last scan: ${last == null ? 'Never' : _fmtTime(last)}',
              style: GoogleFonts.manrope(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
            if (!granted)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: GestureDetector(
                  onTap: openAppSettings,
                  child: Text(
                    'Open app settings to allow music permission',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
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

class _TrackRow extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;

  const _TrackRow({required this.track, required this.isPlaying, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            const SizedBox(width: 8),
            const Icon(Icons.more_vert_rounded, color: AppColors.onSurfaceVariant, size: 18),
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
