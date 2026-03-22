import 'stream_discovery_models.dart';

abstract class StreamBackendGateway {
  Future<UserEntitlement> fetchEntitlement({required String provider});

  Future<StreamDiscoveryResult> searchCatalog({
    required String provider,
    required StreamDiscoveryRequest request,
  });

  Future<Uri?> resolvePlaybackUri({
    required String provider,
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  });
}

class NoopStreamBackendGateway implements StreamBackendGateway {
  const NoopStreamBackendGateway();

  @override
  Future<UserEntitlement> fetchEntitlement({required String provider}) async {
    return const UserEntitlement(
      authenticated: false,
      hasPremium: false,
      regionAllowed: false,
      providerUserId: '',
      statusMessage: 'Sign in and official API backend configuration are required.',
    );
  }

  @override
  Future<StreamDiscoveryResult> searchCatalog({
    required String provider,
    required StreamDiscoveryRequest request,
  }) async {
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
        code: 'backend_not_configured',
        message: 'Streaming backend is not configured for official provider APIs.',
        userActionable: true,
      ),
    );
  }

  @override
  Future<Uri?> resolvePlaybackUri({
    required String provider,
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    return null;
  }
}
