import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/music_models.dart';
import '../services/youtube_service.dart';
import '../theme/app_theme.dart';
import 'youtube_player_screen.dart';

const String _kApiKeyPref = 'yt_api_key';

/// Discover / YouTube search screen.
///
/// Allows users to search for music on YouTube and stream results using the
/// official YouTube IFrame player. Requires a YouTube Data API v3 key.
class YouTubeSearchScreen extends StatefulWidget {
  const YouTubeSearchScreen({super.key});

  @override
  State<YouTubeSearchScreen> createState() => _YouTubeSearchScreenState();
}

class _YouTubeSearchScreenState extends State<YouTubeSearchScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final TextEditingController _apiKeyCtrl = TextEditingController();

  String _query = '';
  String _apiKey = '';
  List<YouTubeVideoResult> _results = const [];
  bool _isLoading = false;
  String? _error;
  bool _showApiKeyField = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kApiKeyPref) ?? '';
    setState(() {
      _apiKey = stored;
      _apiKeyCtrl.text = stored;
      _showApiKeyField = stored.isEmpty;
    });
  }

  Future<void> _saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kApiKeyPref, key.trim());
    setState(() {
      _apiKey = key.trim();
      _showApiKeyField = key.trim().isEmpty;
      _error = null;
    });
  }

  Future<void> _search() async {
    final q = _query.trim();
    if (q.isEmpty) return;
    if (_apiKey.isEmpty) {
      setState(() {
        _error = 'Set your YouTube Data API v3 key above to search.';
        _showApiKeyField = true;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await YouTubeService.searchMusic(q, _apiKey);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } on YouTubeServiceException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Search failed: $e';
        _isLoading = false;
      });
    }
  }

  void _openPlayer(YouTubeVideoResult video) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, a1, a2) => YouTubePlayerScreen(video: video),
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    ));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Discover',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(
                        () => _showApiKeyField = !_showApiKeyField),
                    icon: Icon(
                      Icons.settings_rounded,
                      color: _apiKey.isEmpty
                          ? const Color(0xFFFF9AA6)
                          : AppColors.onSurfaceVariant,
                    ),
                    tooltip: 'YouTube API key settings',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Stream music from YouTube',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            // ── API key setup ────────────────────────────────────────────────
            if (_showApiKeyField) ...[
              const SizedBox(height: 16),
              _ApiKeyPanel(
                controller: _apiKeyCtrl,
                onSave: _saveApiKey,
              ),
            ],
            const SizedBox(height: 20),
            // ── Search bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() {
                  _query = v;
                  _error = null;
                }),
                onSubmitted: (_) => _search(),
                textInputAction: TextInputAction.search,
                style: GoogleFonts.manrope(
                    color: AppColors.onSurface, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search for music on YouTube...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.onSurfaceVariant, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() {
                              _query = '';
                              _results = const [];
                              _error = null;
                            });
                          },
                          child: const Icon(Icons.close_rounded,
                              color: AppColors.onSurfaceVariant, size: 18),
                        )
                      : null,
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: Text(
                  _error!,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFFFF9AA6),
                  ),
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            const SizedBox(height: 8),
            // ── Results ──────────────────────────────────────────────────────
            Expanded(
              child: _results.isEmpty && !_isLoading
                  ? _EmptyState(hasApiKey: _apiKey.isNotEmpty)
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(16, 8, 16, 160),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 4),
                      itemBuilder: (_, i) => _VideoResultTile(
                        video: _results[i],
                        onTap: () => _openPlayer(_results[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── API key setup panel ──────────────────────────────────────────────────────
class _ApiKeyPanel extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSave;

  const _ApiKeyPanel({required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceContainerHigh,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.key_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'YouTube Data API v3 Key',
                  style: GoogleFonts.epilogue(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Obtain a free key from the Google Cloud Console with the '
              '"YouTube Data API v3" enabled. Your key is stored locally on '
              'this device only.',
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              style: GoogleFonts.manrope(
                  color: AppColors.onSurface, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'AIza...',
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                ),
              ),
              onSubmitted: onSave,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () => onSave(controller.text),
                child: const Text('Save Key'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Video result tile ────────────────────────────────────────────────────────
class _VideoResultTile extends StatelessWidget {
  final YouTubeVideoResult video;
  final VoidCallback onTap;

  const _VideoResultTile({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surfaceContainerHigh,
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: video.thumbnailUrl.isNotEmpty
                  ? Image.network(
                      video.thumbnailUrl,
                      width: 80,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _ThumbFallback(),
                    )
                  : _ThumbFallback(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: GoogleFonts.epilogue(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.channelTitle.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.play_circle_outline_rounded,
                color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }
}

class _ThumbFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFF2A1B4E),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(Icons.music_video_rounded,
          color: AppColors.primary, size: 28),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool hasApiKey;
  const _EmptyState({required this.hasApiKey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasApiKey
                  ? Icons.youtube_searched_for_rounded
                  : Icons.key_off_rounded,
              size: 64,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              hasApiKey
                  ? 'Search for music to stream'
                  : 'Set up your YouTube API key',
              style: GoogleFonts.epilogue(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasApiKey
                  ? 'Type a song, artist, or album above and tap search.'
                  : 'Tap the settings icon above and enter your Google API key '
                      'with YouTube Data API v3 enabled.',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
