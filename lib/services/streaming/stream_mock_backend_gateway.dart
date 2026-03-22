import 'dart:math';

import 'stream_backend_gateway.dart';
import 'stream_discovery_models.dart';

class MockYouTubeBackendGateway implements StreamBackendGateway {
  const MockYouTubeBackendGateway();

  @override
  Future<UserEntitlement> fetchEntitlement({required String provider}) async {
    return const UserEntitlement(
      authenticated: true,
      hasPremium: true,
      regionAllowed: true,
      providerUserId: 'demo-user',
      statusMessage: 'Demo mode is enabled. Results are mocked for UI testing only.',
    );
  }

  @override
  Future<StreamDiscoveryResult> searchCatalog({
    required String provider,
    required StreamDiscoveryRequest request,
  }) async {
    final query = request.query.trim();
    if (query.isEmpty) {
      return const StreamDiscoveryResult(
        error: DiscoveryError(
          code: 'empty_query',
          message: 'Search query is empty.',
          userActionable: true,
        ),
      );
    }

    final seed = query.toLowerCase().hashCode;
    final random = Random(seed);
    final candidates = List.generate(6, (index) {
      final locked = index.isOdd;
      return StreamCandidate(
        id: 'yt_demo_${query.replaceAll(' ', '_')}_$index',
        title: '$query Demo Mix ${index + 1}',
        artist: 'Creator ${String.fromCharCode(65 + index)}',
        provider: provider,
        duration: Duration(minutes: 2 + random.nextInt(4), seconds: random.nextInt(60)),
        requiresEntitlement: locked,
      );
    });

    return StreamDiscoveryResult(candidates: candidates);
  }

  @override
  Future<Uri?> resolvePlaybackUri({
    required String provider,
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    if (!entitlement.canAttemptPlayback) {
      return null;
    }
    if (candidate.requiresEntitlement && !entitlement.canAttemptPlayback) {
      return null;
    }
    return candidate.playbackUri ?? Uri.parse('https://demo.invalid/$provider/${candidate.id}.mp3');
  }
}
