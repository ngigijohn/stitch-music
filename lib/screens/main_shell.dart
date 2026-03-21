import 'package:flutter/material.dart';
import '../services/playback_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/mini_player.dart';
import '../widgets/glass_nav_bar.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'playlists_screen.dart';
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
    PlaylistsScreen(),
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
