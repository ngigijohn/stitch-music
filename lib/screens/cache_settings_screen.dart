import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/cache_service.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';

class CacheSettingsScreen extends StatefulWidget {
  const CacheSettingsScreen({super.key});

  @override
  State<CacheSettingsScreen> createState() => _CacheSettingsScreenState();
}

class _CacheSettingsScreenState extends State<CacheSettingsScreen> {
  final CacheService _cache = CacheService.instance;
  final PlaybackController _playback = PlaybackController.instance;

  @override
  void initState() {
    super.initState();
    _cache.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _cache.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
        child: Text(
          label,
          style: GoogleFonts.epilogue(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      );

  Widget _card({required Widget child}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: child,
        ),
      );

  // ── Offline toggle ────────────────────────────────────────────────────────────

  Widget _offlineToggle() => _card(
        child: SwitchListTile.adaptive(
          value: _cache.isOfflineMode,
          onChanged: (v) => _cache.setOfflineMode(v),
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primaryContainer,
          title: Text(
            'Offline Mode',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          subtitle: Text(
            _cache.isOfflineMode
                ? 'Cloud features disabled — playing from device only'
                : 'Online search and streaming are available',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          secondary: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              _cache.isOfflineMode
                  ? Icons.wifi_off_rounded
                  : Icons.wifi_rounded,
              key: ValueKey(_cache.isOfflineMode),
              color: _cache.isOfflineMode
                  ? const Color(0xFFFF6B35)
                  : AppColors.primary,
            ),
          ),
        ),
      );

  // ── Stats row ─────────────────────────────────────────────────────────────────

  Widget _statsRow() {
    final libraryCount = _playback.library.length;
    final pinned = _cache.pinnedCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.library_music_rounded,
            value: '$libraryCount',
            label: 'In library',
            color: AppColors.secondary,
          ),
          const SizedBox(width: 12),
          _StatChip(
            icon: Icons.download_done_rounded,
            value: '$pinned',
            label: 'Pinned',
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          _StatChip(
            icon: Icons.storage_rounded,
            value: '${_cache.limitMb}MB',
            label: 'Cache limit',
            color: const Color(0xFF26A69A),
          ),
        ],
      ),
    );
  }

  // ── Cache size slider ─────────────────────────────────────────────────────────

  Widget _limitSlider() => _card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.storage_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cache Size Limit',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${_cache.limitMb} MB',
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Slider(
                value: _cache.limitMb.toDouble(),
                min: 10,
                max: 500,
                divisions: 49,
                activeColor: AppColors.primary,
                inactiveColor:
                    AppColors.primary.withValues(alpha: 0.2),
                label: '${_cache.limitMb} MB',
                onChanged: (v) =>
                    _cache.setLimitMb(v.round()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('10 MB',
                      style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant)),
                  Text('500 MB',
                      style: GoogleFonts.manrope(
                          fontSize: 10,
                          color: AppColors.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
      );

  // ── Pinned tracks list ────────────────────────────────────────────────────────

  Widget _pinnedTracksList() {
    if (_cache.pinnedIds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const Icon(Icons.download_for_offline_outlined,
                  color: AppColors.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No pinned tracks yet.\nTap the download icon on any track in your Library.',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pinnedTracks = _playback.library
        .where((t) => _cache.isPinned(t.id))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: pinnedTracks.map((track) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.download_done_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.onSurfaceVariant),
                    onPressed: () => _cache.unpinTrack(track.id),
                    tooltip: 'Unpin',
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Clear all button ──────────────────────────────────────────────────────────

  Widget _clearButton() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: OutlinedButton.icon(
          onPressed: _showClearDialog,
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFEF5350),
            side: const BorderSide(color: Color(0xFFEF5350)),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.delete_outline_rounded, size: 18),
          label: Text(
            'Clear All Cache Data',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
          ),
        ),
      );

  void _showClearDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHighest,
        title: Text('Clear cache?',
            style: GoogleFonts.epilogue(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface)),
        content: Text(
          'This removes all pinned tracks and resets cache settings. Your library and playlists are not affected.',
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.manrope(
                    color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              _cache.clearAll();
              Navigator.pop(context);
            },
            child: Text('Clear',
                style: GoogleFonts.manrope(
                    color: const Color(0xFFEF5350),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 110,
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18),
              color: AppColors.onSurface,
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Offline & Cache',
                style: GoogleFonts.epilogue(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
              titlePadding:
                  const EdgeInsets.fromLTRB(52, 0, 0, 16),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: Listenable.merge([_cache, _playback]),
              builder: (_, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _sectionHeader('MODE'),
                  _offlineToggle(),
                  _sectionHeader('STORAGE'),
                  _statsRow(),
                  const SizedBox(height: 16),
                  _limitSlider(),
                  _sectionHeader('PINNED TRACKS'),
                  _pinnedTracksList(),
                  _clearButton(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 10,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
