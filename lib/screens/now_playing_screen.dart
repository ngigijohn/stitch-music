import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stitch_music/l10n/app_localizations.dart';

import '../services/audio_effects_service.dart';
import '../services/export_service.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'insights_screen.dart';
import 'queue_screen.dart';
import 'settings_screen.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  final PlaybackController _playback = PlaybackController.instance;



  late final AnimationController _meshController;
  late final AnimationController _albumPulseController;

  @override
  void initState() {
    super.initState();
    _meshController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
    _albumPulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _meshController.dispose();
    _albumPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _playback,
      builder: (context, _) {
        final track = _playback.currentTrack;
        if (track == null) {
          return Scaffold(
            body: Center(child: Text(AppLocalizations.of(context)!.nowPlayingNothingPlaying)),
          );
        }

        final int durationMs = _playback.duration.inMilliseconds;
        final int positionMs = _playback.position.inMilliseconds.clamp(0, durationMs <= 0 ? 0 : durationMs);
        final double progress = durationMs <= 0 ? 0 : positionMs / durationMs;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              _AnimatedMeshBg(controller: _meshController),
              Positioned(
                top: -60,
                right: -80,
                child: AnimatedBuilder(
                  animation: _albumPulseController,
                  builder: (_, __) {
                    final val = _albumPulseController.value;
                    return Container(
                      width: 360,
                      height: 360,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.18 + val * 0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(context),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            _buildAlbumArt(),
                            const SizedBox(height: 28),
                            _buildTrackInfo(track.title, track.artist, track.album, track.id),
                            const SizedBox(height: 24),
                            _buildProgress(progress),
                            const SizedBox(height: 22),
                            _buildMainControls(),
                            const SizedBox(height: 18),
                            _buildSecondaryControls(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: AppLocalizations.of(context)!.nowPlayingCollapsePlayer,
            icon: const Icon(Icons.expand_more_rounded, size: 30),
            color: AppColors.onSurface,
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.nowPlayingFromDevice,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 2.5,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showTrackActionsSheet(context),
            tooltip: AppLocalizations.of(context)!.nowPlayingTrackActionsTooltip,
            icon: const Icon(Icons.more_vert_rounded, size: 24),
            color: AppColors.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt() {
    return AnimatedBuilder(
      animation: _albumPulseController,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(52),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15 + _albumPulseController.value * 0.15),
                    blurRadius: 60 + _albumPulseController.value * 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 48,
              height: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A1D96), Color(0xFF7C3AED), Color(0xFF2E1065)],
                ),
              ),
              child: const Center(
                child: Icon(Icons.music_note_rounded, size: 100, color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrackInfo(String title, String artist, String album, String trackId) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.epilogue(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '$artist • $album',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _playback.toggleFavorite(trackId),
          child: Semantics(
            label: _playback.isFavorite(trackId) ? AppLocalizations.of(context)!.nowPlayingRemoveFromFavorites : AppLocalizations.of(context)!.nowPlayingAddToFavorites,
            button: true,
            toggled: _playback.isFavorite(trackId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _playback.isFavorite(trackId) ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
              ),
              child: Icon(
                _playback.isFavorite(trackId) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _playback.isFavorite(trackId) ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(double progress) {
    final Duration position = _playback.position;
    final Duration duration = _playback.duration;

    return Column(
      children: [
        Semantics(
          label: AppLocalizations.of(context)!.nowPlayingSeekLabel,
          value: '${_fmt(position)} / ${_fmt(duration)}',
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.outlineVariant.withValues(alpha: 0.4),
              trackHeight: 3,
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: _playback.seekToFraction,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(position), style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
              Text(_fmt(duration), style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _playback.toggleShuffle,
          icon: Icon(Icons.shuffle_rounded, color: _playback.shuffleEnabled ? AppColors.primary : AppColors.onSurfaceVariant),
        ),
        IconButton(
          onPressed: _playback.skipPrevious,
          iconSize: 44,
          icon: const Icon(Icons.skip_previous_rounded, color: AppColors.onSurface),
        ),
        GestureDetector(
          onTap: _playback.togglePlayPause,
          child: Semantics(
            label: _playback.isPlaying ? AppLocalizations.of(context)!.nowPlayingPause : AppLocalizations.of(context)!.nowPlayingResumeSemantic,
            button: true,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryContainer]),
              ),
              child: Icon(
                _playback.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: AppColors.onPrimary,
                size: 42,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _playback.skipNext,
          iconSize: 44,
          icon: const Icon(Icons.skip_next_rounded, color: AppColors.onSurface),
        ),
        IconButton(
          onPressed: _playback.cycleRepeat,
          icon: Icon(
            _playback.repeatMode == QueueRepeatMode.one ? Icons.repeat_one_rounded : Icons.repeat_rounded,
            color: _playback.repeatMode != QueueRepeatMode.none ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryControls() {
    final eq = AudioEffectsService.instance;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Pill(
          icon: Icons.volume_up_rounded,
          label: AppLocalizations.of(context)!.nowPlayingVolumeLabel,
          onTap: () => _showVolumeSheet(context),
        ),
        _Pill(
          icon: Icons.speed_rounded,
          label: AppLocalizations.of(context)!.nowPlayingSpeedLabel,
          onTap: () => _showSpeedSheet(context),
        ),
        _Pill(
          icon: Icons.equalizer_rounded,
          label: AppLocalizations.of(context)!.nowPlayingEqLabel,
          isActive: eq.isEnabled && eq.activePresetId != EqPresetId.normal,
          onTap: () => _showEqPanel(context),
        ),
        _Pill(
          icon: Icons.share_rounded,
          label: AppLocalizations.of(context)!.nowPlayingShareLabel,
          onTap: () => _showTrackShareSheet(context),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: AppColors.glassPanel,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            _BottomBarBtn(icon: Icons.devices_rounded, label: AppLocalizations.of(context)!.nowPlayingDevicesLabel, onTap: () => _showDevicesSheet(context)),
            _BottomBarBtn(
              icon: Icons.queue_music_rounded,
              label: AppLocalizations.of(context)!.nowPlayingQueueLabel,
              isActive: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const QueueScreen(),
                );
              },
            ),
            _BottomBarBtn(
              icon: Icons.share_rounded,
              label: AppLocalizations.of(context)!.nowPlayingShareLabel,
              onTap: () => _showTrackShareSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    final int m = d.inMinutes;
    final int s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _showTrackShareSheet(BuildContext context) {
    final track = _playback.currentTrack;
    if (track == null) return;
    final export = ExportService.instance;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
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
                  const Icon(Icons.share_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      track.title,
                      style: GoogleFonts.epilogue(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${track.artist} • ${track.album}',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const Divider(indent: 20, endIndent: 20),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.copy_rounded,
                    color: AppColors.primary, size: 20),
              ),
              title: Text(
                AppLocalizations.of(context)!.nowPlayingCopyTrackInfo,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              subtitle: Text(
                export.trackInline(track),
                style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.copy_rounded,
                  size: 16, color: AppColors.onSurfaceVariant),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: export.trackCard(track)));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.nowPlayingCopiedToClipboard),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.format_list_bulleted_rounded,
                    color: AppColors.secondary, size: 20),
              ),
              title: Text(
                AppLocalizations.of(context)!.nowPlayingCopyQueueLabel,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              subtitle: Text(
                AppLocalizations.of(context)!.nowPlayingQueueCount(_playback.queue.length),
                style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant),
              ),
              trailing: const Icon(Icons.copy_rounded,
                  size: 16, color: AppColors.onSurfaceVariant),
              onTap: () {
                final queueText = _playback.queue
                    .asMap()
                    .entries
                    .map((e) =>
                        '${(e.key + 1).toString().padLeft(2)}. ${e.value.artist} - ${e.value.title}  [${e.value.duration}]')
                    .join('\n');
                Clipboard.setData(ClipboardData(text: queueText));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.nowPlayingQueueCopied),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showEqPanel(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _EqPanel(),
    );
  }

  void _showDevicesSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ActionSheetFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionSheetTile(
              icon: Icons.phone_android_rounded,
              title: AppLocalizations.of(context)!.nowPlayingThisDevice,
              subtitle: AppLocalizations.of(context)!.nowPlayingThisDeviceSubtitle,
              onTap: () => Navigator.pop(ctx),
            ),
            _ActionSheetTile(
              icon: Icons.bluetooth_audio_rounded,
              title: AppLocalizations.of(context)!.nowPlayingBluetooth,
              subtitle: AppLocalizations.of(context)!.nowPlayingBluetoothSubtitle,
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showVolumeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => _ActionSheetFrame(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.nowPlayingVolumeSheetTitle, style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(AppLocalizations.of(context)!.nowPlayingVolumeSheetSubtitle, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
                Semantics(
                  label: AppLocalizations.of(context)!.nowPlayingVolumeSheetTitle,
                  hint: AppLocalizations.of(context)!.nowPlayingVolumeSheetSubtitle,
                  value: '${(_playback.volume * 100).round()}%',
                  child: Slider(
                    value: _playback.volume,
                    onChanged: (value) async {
                      await _playback.setVolume(value);
                      setSheetState(() {});
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${(_playback.volume * 100).round()}%', style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSpeedSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => _ActionSheetFrame(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.nowPlayingSpeedSheetTitle, style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(AppLocalizations.of(context)!.nowPlayingSpeedSheetSubtitle, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
                Semantics(
                  label: AppLocalizations.of(context)!.nowPlayingSpeedSheetTitle,
                  hint: AppLocalizations.of(context)!.nowPlayingSpeedSheetSubtitle,
                  value: '${_playback.speed.toStringAsFixed(2)}x',
                  child: Slider(
                    min: 0.5,
                    max: 2.0,
                    divisions: 6,
                    value: _playback.speed,
                    onChanged: (value) async {
                      await _playback.setSpeed(value);
                      setSheetState(() {});
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('${_playback.speed.toStringAsFixed(2)}x', style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTrackActionsSheet(BuildContext context) {
    final track = _playback.currentTrack;
    if (track == null) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ActionSheetFrame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionSheetTile(
              icon: _playback.isFavorite(track.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              title: _playback.isFavorite(track.id) ? AppLocalizations.of(context)!.nowPlayingRemoveFavorite : AppLocalizations.of(context)!.nowPlayingAddFavorite,
              subtitle: AppLocalizations.of(context)!.nowPlayingFavoriteSubtitle,
              onTap: () async {
                await _playback.toggleFavorite(track.id);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
              },
            ),
            _ActionSheetTile(
              icon: Icons.playlist_add_rounded,
              title: AppLocalizations.of(context)!.nowPlayingAddToPlaylist,
              subtitle: AppLocalizations.of(context)!.nowPlayingAddToPlaylistSubtitle,
              onTap: () {
                Navigator.pop(ctx);
                _showAddToPlaylistSheet(context, track);
              },
            ),
            _ActionSheetTile(
              icon: Icons.share_rounded,
              title: AppLocalizations.of(context)!.nowPlayingShareTrack,
              subtitle: AppLocalizations.of(context)!.nowPlayingShareTrackSubtitle,
              onTap: () {
                Navigator.pop(ctx);
                _showTrackShareSheet(context);
              },
            ),
            _ActionSheetTile(
              icon: Icons.bar_chart_rounded,
              title: AppLocalizations.of(context)!.nowPlayingOpenInsights,
              subtitle: AppLocalizations.of(context)!.nowPlayingOpenInsightsSubtitle,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InsightsScreen()));
              },
            ),
            _ActionSheetTile(
              icon: Icons.settings_rounded,
              title: AppLocalizations.of(context)!.nowPlayingOpenSettings,
              subtitle: AppLocalizations.of(context)!.nowPlayingOpenSettingsSubtitle,
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showAddToPlaylistSheet(BuildContext context, dynamic track) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AnimatedBuilder(
        animation: _playback,
        builder: (ctx, __) {
          final playlists = _playback.playlists;
          return _ActionSheetFrame(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.playlist_add_rounded, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(AppLocalizations.of(context)!.nowPlayingAddToPlaylist, style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                ),
                if (playlists.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      AppLocalizations.of(context)!.nowPlayingNoPlaylistsCreate,
                      style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 280),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: playlists.length,
                      itemBuilder: (_, index) {
                        final playlist = playlists[index];
                        final alreadyIn = playlist.trackIds.contains(track.id);
                        return ListTile(
                          leading: Icon(
                            alreadyIn ? Icons.check_circle_rounded : Icons.playlist_add_rounded,
                            color: alreadyIn ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                          title: Text(playlist.name),
                          subtitle: Text(AppLocalizations.of(ctx)!.playlistsTrackCount(playlist.trackIds.length)),
                          onTap: alreadyIn
                              ? null
                              : () async {
                                  await _playback.addTrackToPlaylist(playlist.id, track.id);
                                  if (!ctx.mounted) return;
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(AppLocalizations.of(context)!.nowPlayingAddedToPlaylist(playlist.name))),
                                  );
                                },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedMeshBg extends StatelessWidget {
  final AnimationController controller;
  const _AnimatedMeshBg({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 2, -1),
              end: Alignment(1 - t * 2, 1),
              colors: const [Color(0xFF141218), Color(0xFF2C203C), Color(0xFF1A1A2E), Color(0xFF120B1A)],
              stops: const [0.0, 0.33, 0.66, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const _Pill({required this.icon, required this.label, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: onTap != null
                ? AppColors.surfaceContainerHigh
                : AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
            border: isActive
                ? Border.all(color: AppColors.primary.withValues(alpha: 0.6))
                : null,
          ),
          child: Column(
            children: [
              Icon(icon, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant, size: 22),
              const SizedBox(height: 4),
              Text(label, style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBarBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomBarBtn({required this.icon, required this.label, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: label,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: isActive
                ? BoxDecoration(borderRadius: BorderRadius.circular(999), color: AppColors.primaryContainer.withValues(alpha: 0.25))
                : null,
            child: Column(
              children: [
                Icon(icon, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionSheetFrame extends StatelessWidget {
  final Widget child;

  const _ActionSheetFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.75;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
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
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionSheetTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionSheetTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      hint: subtitle,
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withValues(alpha: 0.14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: GoogleFonts.manrope(fontWeight: FontWeight.w800)),
        subtitle: Text(subtitle, style: GoogleFonts.manrope(fontSize: 12, color: AppColors.onSurfaceVariant)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

// ─── EQ Panel bottom sheet ────────────────────────────────────────────────────

class _EqPanel extends StatefulWidget {
  const _EqPanel();

  @override
  State<_EqPanel> createState() => _EqPanelState();
}

class _EqPanelState extends State<_EqPanel> {
  final AudioEffectsService _eq = AudioEffectsService.instance;

  @override
  void initState() {
    super.initState();
    _eq.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _eq.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bands = _eq.activeBands;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.45)),
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
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.equalizer_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.settingsEqTitle,
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: _eq.isEnabled,
                  onChanged: (v) => _eq.setEnabled(v),
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                ),
                IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  color: AppColors.onSurfaceVariant,
                  tooltip: AppLocalizations.of(context)!.nowPlayingOpenSettings,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          // Active preset chip
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _eq.isEnabled ? _eq.activePreset.name : AppLocalizations.of(context)!.settingsDisabledLabel,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          // Preset quick-select
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: kBuiltinPresets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final preset = kBuiltinPresets[i];
                final selected = _eq.activePresetId == preset.id;
                return ChoiceChip(
                  label: Text(preset.name),
                  selected: selected,
                  onSelected: (_) => _eq.selectPreset(preset.id),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  labelStyle: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Five band sliders
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(5, (i) {
                final gain = bands.gains[i];
                return Expanded(
                  child: Column(
                    children: [
                      Text(
                        gain >= 0 ? '+${gain.round()}' : '${gain.round()}',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: gain.abs() > 0.5
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                      Semantics(
                        label: '${AppLocalizations.of(context)!.settingsEqTitle} ${kEqBandLabels[i]}',
                        value: gain.round().toString(),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                              activeTrackColor: AppColors.primary,
                              inactiveTrackColor: AppColors.outlineVariant.withValues(alpha: 0.4),
                            ),
                            child: SizedBox(
                              width: 100,
                              child: Slider(
                                value: gain.clamp(-12.0, 12.0),
                                min: -12,
                                max: 12,
                                divisions: 24,
                                onChanged: _eq.isEnabled
                                    ? (v) => _eq.setCustomBand(i, v)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        kEqBandLabels[i],
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _eq.resetToFlat,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: Text(
              AppLocalizations.of(context)!.settingsResetEq,
              style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

