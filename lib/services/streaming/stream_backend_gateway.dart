import 'stream_discovery_models.dart';
import 'stream_auth_service.dart';

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
  final StreamAuthService _auth;

  const NoopStreamBackendGateway({StreamAuthService authService = const NoopStreamAuthService()})
      : _auth = authService;

  @override
  Future<UserEntitlement> fetchEntitlement({required String provider}) async {
    final authState = await _auth.refreshState(provider: provider);
    return UserEntitlement(
      authenticated: authState.canCallEntitledApis,
      hasPremium: false,
      regionAllowed: false,
      providerUserId: authState.session?.providerUserId ?? '',
      statusMessage: authState.message ??
          'Sign in and official API backend configuration are required.',
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

class ProviderBackendContract {
  final Uri? entitlementEndpoint;
  final Uri? catalogEndpoint;
  final Uri? playbackResolveEndpoint;

  const ProviderBackendContract({
    this.entitlementEndpoint,
    this.catalogEndpoint,
    this.playbackResolveEndpoint,
  });

  bool get isConfigured =>
      entitlementEndpoint != null &&
      catalogEndpoint != null &&
      playbackResolveEndpoint != null;
}

class ProductionContractStreamBackendGateway implements StreamBackendGateway {
  final StreamAuthService _auth;
  final Map<String, ProviderBackendContract> _contracts;

  const ProductionContractStreamBackendGateway({
    required Map<String, ProviderBackendContract> providerContracts,
    StreamAuthService authService = const NoopStreamAuthService(),
  })  : _contracts = providerContracts,
        _auth = authService;

  @override
  Future<UserEntitlement> fetchEntitlement({required String provider}) async {
    final contract = _contracts[provider];
    if (contract == null || !contract.isConfigured) {
      return const UserEntitlement(
        authenticated: false,
        hasPremium: false,
        regionAllowed: false,
        providerUserId: '',
        statusMessage: 'Provider contract is not configured for production calls.',
      );
    }

    final authState = await _auth.refreshState(provider: provider);
    if (!authState.canCallEntitledApis || authState.session == null) {
      return UserEntitlement(
        authenticated: false,
        hasPremium: false,
        regionAllowed: false,
        providerUserId: authState.session?.providerUserId ?? '',
        statusMessage: authState.message ?? 'Provider sign-in is required.',
      );
    }

    // Production entitlement API integration is intentionally not implemented here yet.
    // Until official backend calls are wired, remain fail-closed for premium/region checks.
    return UserEntitlement(
      authenticated: true,
      hasPremium: false,
      regionAllowed: false,
      providerUserId: authState.session!.providerUserId,
      statusMessage: 'Authenticated, but entitlement backend call is pending implementation.',
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

    final contract = _contracts[provider];
    if (contract == null || !contract.isConfigured) {
      return const StreamDiscoveryResult(
        error: DiscoveryError(
          code: 'backend_not_configured',
          message: 'Provider production backend contract is missing.',
          userActionable: true,
        ),
      );
    }

    return const StreamDiscoveryResult(
      error: DiscoveryError(
        code: 'backend_unimplemented',
        message: 'Production search endpoint integration is pending. Failing closed by design.',
        userActionable: false,
      ),
    );
  }

  @override
  Future<Uri?> resolvePlaybackUri({
    required String provider,
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  }) async {
    final contract = _contracts[provider];
    if (contract == null || !contract.isConfigured) {
      return null;
    }
    if (!entitlement.canAttemptPlayback) {
      return null;
    }

    // Intentionally fail-closed until official provider URI resolution API is integrated.
    return null;
  }
}
