import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_localizations.dart';
import '../services/playback_controller.dart';
import '../services/streaming/stream_adapter_registry.dart';
import '../services/streaming/online_search_activity_service.dart';
import '../services/streaming/stream_discovery_models.dart';
import '../theme/app_theme.dart';

class OnlineSearchScreen extends StatefulWidget {
  const OnlineSearchScreen({super.key});

  @override
  State<OnlineSearchScreen> createState() => _OnlineSearchScreenState();
}

class _OnlineSearchScreenState extends State<OnlineSearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  final OnlineSearchActivityService _activity = OnlineSearchActivityService.instance;
  final PlaybackController _playback = PlaybackController.instance;

  static const String _provider = 'youtube';

  UserEntitlement? _entitlement;
  StreamDiscoveryResult? _result;
  bool _loadingEntitlement = true;
  bool _searching = false;
  bool _demoMode = true;
  String? _resolvingCandidateId;

  StreamAdapterRegistry get _registry =>
      _demoMode ? StreamAdapterRegistry.demoRegistry() : StreamAdapterRegistry.defaultRegistry();

  @override
  void initState() {
    super.initState();
    _refreshEntitlement();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _refreshEntitlement() async {
    setState(() => _loadingEntitlement = true);
    final adapter = _registry.byProvider(_provider);
    if (adapter == null) {
      setState(() {
        _loadingEntitlement = false;
        _entitlement = UserEntitlement(
          authenticated: false,
          hasPremium: false,
          regionAllowed: false,
          providerUserId: '',
          statusMessage: AppLocalizations.of(context)!.onlineSearchProviderUnavailable,
        );
      });
      return;
    }

    final ent = await adapter.fetchEntitlement();
    if (!mounted) return;
    setState(() {
      _entitlement = ent;
      _loadingEntitlement = false;
    });
  }

  Future<void> _runSearch() async {
    final q = _queryController.text.trim();
    if (q.isEmpty) return;

    final adapter = _registry.byProvider(_provider);
    if (adapter == null) {
      setState(() {
        _result = StreamDiscoveryResult(
          error: DiscoveryError(
            code: 'adapter_missing',
            message: AppLocalizations.of(context)!.onlineSearchProviderUnavailable,
            userActionable: false,
          ),
        );
      });
      return;
    }

    setState(() => _searching = true);
    final res = await adapter.search(StreamDiscoveryRequest(query: q));
    if (!mounted) return;
    setState(() {
      _result = res;
      _searching = false;
    });
    _activity.recordSearch(
      query: q,
      provider: _provider,
      resultCount: res.candidates.length,
      demoMode: _demoMode,
    );
  }

  Future<void> _queueCandidate(StreamCandidate candidate) async {
    await _resolveAndQueueCandidate(candidate, playNow: false);
  }

  Future<void> _playCandidateNow(StreamCandidate candidate) async {
    await _resolveAndQueueCandidate(candidate, playNow: true);
  }

  Future<void> _resolveAndQueueCandidate(StreamCandidate candidate, {required bool playNow}) async {
    final adapter = _registry.byProvider(_provider);
    final entitlement = _entitlement;
    if (adapter == null || entitlement == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.onlineSearchProviderUnavailable)),
      );
      return;
    }

    if (candidate.requiresEntitlement && !entitlement.canAttemptPlayback) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.onlineSearchEntitlementRequired)),
      );
      return;
    }

    setState(() => _resolvingCandidateId = candidate.id);
    final uri = await adapter.resolvePlaybackUri(
      candidate: candidate,
      entitlement: entitlement,
    );
    if (!mounted) return;
    setState(() => _resolvingCandidateId = null);

    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.onlineSearchUriUnavailable),
        ),
      );
      return;
    }

    await _playback.addStreamCandidateToQueue(
      candidate: candidate,
      playbackUri: uri,
      playNow: playNow,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          playNow
              ? AppLocalizations.of(context)!.onlineSearchPlayingNow(candidate.title)
              : AppLocalizations.of(context)!.onlineSearchAddedToQueue(candidate.title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entitlement = _entitlement;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.onlineSearchTitle,
                      style: GoogleFonts.epilogue(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _refreshEntitlement,
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.primary,
                    tooltip: AppLocalizations.of(context)!.onlineSearchRefreshEntitlement,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context)!.onlineSearchDiscoveryNote,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (_loadingEntitlement)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(minHeight: 2),
              )
            else
              _EntitlementBanner(entitlement: entitlement),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  Switch.adaptive(
                    value: _demoMode,
                    onChanged: (value) {
                      setState(() {
                        _demoMode = value;
                        _result = null;
                      });
                      _refreshEntitlement();
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _demoMode
                          ? AppLocalizations.of(context)!.onlineSearchDemoModeLabel
                          : AppLocalizations.of(context)!.onlineSearchProductionModeLabel,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      onSubmitted: (_) => _runSearch(),
                      style: GoogleFonts.manrope(color: AppColors.onSurface, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.onlineSearchHint,
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _searching ? null : _runSearch,
                    icon: const Icon(Icons.travel_explore_rounded, size: 18),
                    label: Text(AppLocalizations.of(context)!.onlineSearchButton),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_searching)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            Expanded(
              child: _ResultPane(
                result: _result,
                resolvingCandidateId: _resolvingCandidateId,
                onQueueCandidate: _queueCandidate,
                onPlayNow: _playCandidateNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntitlementBanner extends StatelessWidget {
  final UserEntitlement? entitlement;

  const _EntitlementBanner({required this.entitlement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ent = entitlement;
    if (ent == null) {
      return _BannerCard(
        color: const Color(0xFFFFC86B),
        icon: Icons.info_outline_rounded,
        title: l10n.onlineSearchEntitlementUnknown,
        body: l10n.onlineSearchEntitlementUnknownBody,
      );
    }

    if (!ent.authenticated) {
      return _BannerCard(
        color: const Color(0xFFFFC86B),
        icon: Icons.lock_outline_rounded,
        title: l10n.onlineSearchSignInRequired,
        body: ent.statusMessage ?? l10n.onlineSearchSignInRequiredBody,
      );
    }

    if (!ent.hasPremium) {
      return _BannerCard(
        color: const Color(0xFFFFC86B),
        icon: Icons.workspace_premium_rounded,
        title: l10n.onlineSearchPremiumRequired,
        body: ent.statusMessage ?? l10n.onlineSearchPremiumRequiredBody,
      );
    }

    if (!ent.regionAllowed) {
      return _BannerCard(
        color: const Color(0xFFFF9AA6),
        icon: Icons.public_off_rounded,
        title: l10n.onlineSearchUnavailableInRegion,
        body: ent.statusMessage ?? l10n.onlineSearchUnavailableInRegionBody,
      );
    }

    return _BannerCard(
      color: const Color(0xFF8FE388),
      icon: Icons.check_circle_rounded,
      title: l10n.onlineSearchEntitled,
      body: l10n.onlineSearchEntitledBody,
    );
  }
}

class _BannerCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;

  const _BannerCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withValues(alpha: 0.12),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPane extends StatelessWidget {
  final StreamDiscoveryResult? result;
  final String? resolvingCandidateId;
  final Future<void> Function(StreamCandidate candidate) onQueueCandidate;
  final Future<void> Function(StreamCandidate candidate) onPlayNow;

  const _ResultPane({
    required this.result,
    required this.resolvingCandidateId,
    required this.onQueueCandidate,
    required this.onPlayNow,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (result == null) {
      return Center(
        child: Text(
          l10n.onlineSearchNoCatalog,
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    if (result!.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            result!.error!.message,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(color: const Color(0xFFFF9AA6), fontSize: 13),
          ),
        ),
      );
    }

    if (result!.candidates.isEmpty) {
      return Center(
        child: Text(
          l10n.onlineSearchNoResults,
          style: GoogleFonts.manrope(color: AppColors.onSurfaceVariant),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
      itemCount: result!.candidates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final c = result!.candidates[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.surfaceContainerHigh.withValues(alpha: 0.65),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
                child: const Icon(Icons.cloud_queue_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${c.artist} • ${c.provider.toUpperCase()}${c.duration == null ? '' : ' • ${_fmtDuration(c.duration!)}'}',
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
              Text(
                c.requiresEntitlement ? l10n.onlineSearchLockedBadge : l10n.onlineSearchOpenBadge,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: c.requiresEntitlement ? const Color(0xFFFFC86B) : const Color(0xFF8FE388),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.tonal(
                onPressed: resolvingCandidateId == c.id ? null : () => onQueueCandidate(c),
                child: resolvingCandidateId == c.id
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        l10n.onlineSearchAddButton,
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                      ),
              ),
              const SizedBox(width: 6),
              FilledButton(
                onPressed: resolvingCandidateId == c.id ? null : () => onPlayNow(c),
                child: Text(
                  l10n.onlineSearchPlayButton,
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _fmtDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
