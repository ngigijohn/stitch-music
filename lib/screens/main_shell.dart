import 'package:flutter/material.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/mini_player.dart';
import '../widgets/glass_nav_bar.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final PlaybackController _playback = PlaybackController.instance;

  // Keep pages alive when switching tabs
  static const _pages = [
    HomeScreen(),
    _DiscoverPlaceholder(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _playback.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Page content
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          // Bottom overlay: mini-player + nav bar
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const MiniPlayer(),
                const SizedBox(height: 8),
                GlassNavBar(
                  selectedIndex: _selectedIndex,
                  onTap: (i) => setState(() => _selectedIndex = i),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Discover placeholder ─────────────────────────────────────────────────────
class _DiscoverPlaceholder extends StatelessWidget {
  const _DiscoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Discover',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 32),
              // Genre grid placeholder
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _GenreTile(label: 'Electronic', color: Color(0xFF4C1D95)),
                  _GenreTile(label: 'Hip-Hop', color: Color(0xFF1E3A5F)),
                  _GenreTile(label: 'Ambient', color: Color(0xFF064E3B)),
                  _GenreTile(label: 'Indie', color: Color(0xFF3B1515)),
                  _GenreTile(label: 'Jazz', color: Color(0xFF292524)),
                  _GenreTile(label: 'R&B', color: Color(0xFF3D1F5B)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenreTile extends StatelessWidget {
  final String label;
  final Color color;
  const _GenreTile({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.9), color.withValues(alpha: 0.5)],
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(16),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}
