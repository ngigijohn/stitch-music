import 'stream_discovery_models.dart';
import 'stream_source_adapter.dart';

/// Policy-compliant placeholder adapter for YouTube discovery.
///
/// Guardrails:
/// - No media extraction from public web pages.
/// - No signature deciphering / scraping / reverse-engineering.
/// - Playback URIs must come from licensed, official APIs with user entitlement.
class YouTubeCompliantDiscoveryAdapter implements StreamSourceAdapter {
  @override
  String get provider => 'youtube';

  @override
  Future<StreamDiscoveryResult> search(StreamDiscoveryRequest request) async {
    // Discovery-only placeholder until official API auth + entitlement flow is wired.
    if (request.query.trim().isEmpty) {
      return const StreamDiscoveryResult(
        error: DiscoveryError(
          code: 'empty_query',
          message: 'Search query is empty.',
          userActionable: true,
        ),
      );
    }

    return const StreamDiscoveryResult(
      error: DiscoveryError(
        code: 'discovery_not_configured',
        message: 'YouTube discovery requires official API credentials and consent flow.',
        userActionable: true,
      ),
    );
  }

  @override
  Future<Uri?> resolvePlaybackUri({
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    // Deliberately returns null until licensed API playback is implemented.
    if (!entitlement.authenticated || !entitlement.hasPremium) {
      return null;
    }
    return null;
  }

  @override
  Future<bool> canPlay({
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    // Conservative by default: do not claim playback support until compliant path exists.
    return false;
  }
}
