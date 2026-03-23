import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import 'queue_screen.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with TickerProviderStateMixin {
  final PlaybackController _playback = PlaybackController.instance;

  bool _isFavorite = false;

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
          return const Scaffold(
            body: Center(child: Text('Nothing is playing yet.')),
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
                            _buildTrackInfo(track.title, track.artist, track.album),
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
            icon: const Icon(Icons.expand_more_rounded, size: 30),
            color: AppColors.onSurface,
          ),
          const Spacer(),
          Text(
            'PLAYING FROM DEVICE',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 2.5,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
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

  Widget _buildTrackInfo(String title, String artist, String album) {
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
          onTap: () => setState(() => _isFavorite = !_isFavorite),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isFavorite ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
            ),
            child: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? AppColors.primary : AppColors.onSurfaceVariant,
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
        SliderTheme(
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
          icon: Icon(Icons.shuffle_rounded, color: _playback.isShuffle ? AppColors.primary : AppColors.onSurfaceVariant),
        ),
        IconButton(
          onPressed: _playback.skipPrevious,
          iconSize: 44,
          icon: const Icon(Icons.skip_previous_rounded, color: AppColors.onSurface),
        ),
        GestureDetector(
          onTap: _playback.togglePlayPause,
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
        IconButton(
          onPressed: _playback.skipNext,
          iconSize: 44,
          icon: const Icon(Icons.skip_next_rounded, color: AppColors.onSurface),
        ),
        IconButton(
          onPressed: _playback.cycleRepeat,
          icon: Icon(
            _playback.repeatMode == 2 ? Icons.repeat_one_rounded : Icons.repeat_rounded,
            color: _playback.repeatMode > 0 ? AppColors.primary : AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _Pill(icon: Icons.volume_up_rounded, label: 'Volume'),
        _Pill(icon: Icons.speed_rounded, label: 'Speed'),
        _Pill(icon: Icons.equalizer_rounded, label: 'EQ'),
        _Pill(icon: Icons.share_rounded, label: 'Share'),
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
            _BottomBarBtn(icon: Icons.devices_rounded, label: 'Devices', onTap: () {}),
            _BottomBarBtn(
              icon: Icons.queue_music_rounded,
              label: 'Queue',
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
            _BottomBarBtn(icon: Icons.share_rounded, label: 'Share', onTap: () {}),
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
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.surfaceContainerHigh),
      child: Column(
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
        ],
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
    );
  }
}
