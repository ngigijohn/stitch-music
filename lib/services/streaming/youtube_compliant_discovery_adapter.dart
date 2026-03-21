import 'stream_discovery_models.dart';
import 'stream_backend_gateway.dart';
import 'stream_source_adapter.dart';

/// Policy-compliant placeholder adapter for YouTube discovery.
///
/// Guardrails:
/// - No media extraction from public web pages.
/// - No signature deciphering / scraping / reverse-engineering.
/// - Playback URIs must come from licensed, official APIs with user entitlement.
class YouTubeCompliantDiscoveryAdapter implements StreamSourceAdapter {
  final StreamBackendGateway _gateway;

  YouTubeCompliantDiscoveryAdapter({required StreamBackendGateway gateway}) : _gateway = gateway;

  @override
  String get provider => 'youtube';

  @override
  Future<UserEntitlement> fetchEntitlement() {
    return _gateway.fetchEntitlement(provider: provider);
  }

  @override
  Future<StreamDiscoveryResult> search(StreamDiscoveryRequest request) async {
    return _gateway.searchCatalog(provider: provider, request: request);
  }

  @override
  Future<Uri?> resolvePlaybackUri({
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    if (!entitlement.canAttemptPlayback) {
      return null;
    }

    return _gateway.resolvePlaybackUri(
      provider: provider,
      candidate: candidate,
      entitlement: entitlement,
    );
  }

  @override
  Future<bool> canPlay({
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    if (!entitlement.canAttemptPlayback) return false;
    final uri = await resolvePlaybackUri(candidate: candidate, entitlement: entitlement);
    return uri != null;
  }
}
