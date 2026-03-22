import 'stream_discovery_models.dart';
import 'stream_auth_service.dart';
import 'stream_http_transport.dart';

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
  final Map<String, String> staticHeaders;

  const ProviderBackendContract({
    this.entitlementEndpoint,
    this.catalogEndpoint,
    this.playbackResolveEndpoint,
    this.staticHeaders = const {},
  });

  bool get isConfigured =>
      entitlementEndpoint != null &&
      catalogEndpoint != null &&
      playbackResolveEndpoint != null;
}

class ProductionContractStreamBackendGateway implements StreamBackendGateway {
  final StreamAuthService _auth;
  final Map<String, ProviderBackendContract> _contracts;
  final StreamHttpTransport _http;

  const ProductionContractStreamBackendGateway({
    required Map<String, ProviderBackendContract> providerContracts,
    StreamAuthService authService = const NoopStreamAuthService(),
    StreamHttpTransport httpTransport = const NoopStreamHttpTransport(),
  })  : _contracts = providerContracts,
        _auth = authService,
        _http = httpTransport;

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

    final response = await _http.getJson(
      uri: contract.entitlementEndpoint!,
      headers: _buildHeaders(contract, authState.session!),
    );
    if (!response.isSuccess || response.jsonBody == null) {
      return UserEntitlement(
        authenticated: true,
        hasPremium: false,
        regionAllowed: false,
        providerUserId: authState.session!.providerUserId,
        statusMessage: 'Entitlement endpoint failed. Remaining fail-closed.',
      );
    }

    final body = response.jsonBody!;
    return UserEntitlement(
      authenticated: _asBool(body['authenticated'], fallback: true),
      hasPremium: _asBool(body['hasPremium']),
      regionAllowed: _asBool(body['regionAllowed']),
      providerUserId: _asString(body['providerUserId'], fallback: authState.session!.providerUserId),
      statusMessage: _asStringOrNull(body['statusMessage']) ?? 'Entitlement evaluated from provider backend.',
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
    final authState = await _auth.refreshState(provider: provider);
    if (!authState.canCallEntitledApis || authState.session == null) {
      return const StreamDiscoveryResult(
        error: DiscoveryError(
          code: 'auth_required',
          message: 'Provider sign-in is required before production search.',
          userActionable: true,
        ),
      );
    }

    final response = await _http.postJson(
      uri: contract.catalogEndpoint!,
      headers: _buildHeaders(contract, authState.session!),
      body: {
        'query': request.query,
        'regionCode': request.regionCode,
        'explicitAllowed': request.explicitAllowed,
      },
    );
    if (!response.isSuccess || response.jsonBody == null) {
      return const StreamDiscoveryResult(
        error: DiscoveryError(
          code: 'catalog_request_failed',
          message: 'Production catalog request failed. Remaining fail-closed.',
          userActionable: false,
        ),
      );
    }

    final body = response.jsonBody!;
    final rawCandidates = body['candidates'];
    if (rawCandidates is! List) {
      return const StreamDiscoveryResult(
        error: DiscoveryError(
          code: 'catalog_payload_invalid',
          message: 'Production catalog response is invalid.',
          userActionable: false,
        ),
      );
    }

    final candidates = <StreamCandidate>[];
    for (final item in rawCandidates) {
      if (item is! Map) continue;
      final map = item.map((k, v) => MapEntry(k.toString(), v));
      final id = _asStringOrNull(map['id']);
      final title = _asStringOrNull(map['title']);
      final artist = _asStringOrNull(map['artist']);
      if (id == null || title == null || artist == null) continue;
      final durationSeconds = _asIntOrNull(map['durationSeconds']);
      final playbackUriRaw = _asStringOrNull(map['playbackUri']);
      candidates.add(
        StreamCandidate(
          id: id,
          title: title,
          artist: artist,
          provider: _asString(map['provider'], fallback: provider),
          playbackUri: playbackUriRaw == null ? null : Uri.tryParse(playbackUriRaw),
          duration: durationSeconds == null ? null : Duration(seconds: durationSeconds),
          requiresEntitlement: _asBool(map['requiresEntitlement'], fallback: true),
        ),
      );
    }

    return StreamDiscoveryResult(candidates: candidates);
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

    final authState = await _auth.refreshState(provider: provider);
    if (!authState.canCallEntitledApis || authState.session == null) {
      return null;
    }

    final response = await _http.postJson(
      uri: contract.playbackResolveEndpoint!,
      headers: _buildHeaders(contract, authState.session!),
      body: {
        'candidateId': candidate.id,
        'provider': candidate.provider,
      },
    );
    if (!response.isSuccess || response.jsonBody == null) return null;

    final playbackUri = _asStringOrNull(response.jsonBody!['playbackUri']);
    if (playbackUri == null || playbackUri.isEmpty) return null;
    return Uri.tryParse(playbackUri);
  }

  Map<String, String> _buildHeaders(
    ProviderBackendContract contract,
    StreamAuthSession session,
  ) {
    return {
      ...contract.staticHeaders,
      'Authorization': 'Bearer ${session.accessToken}',
      'X-Provider-User': session.providerUserId,
      'Content-Type': 'application/json',
    };
  }

  bool _asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    return fallback;
  }

  String _asString(dynamic value, {required String fallback}) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  String? _asStringOrNull(dynamic value) {
    if (value is String && value.isNotEmpty) return value;
    return null;
  }

  int? _asIntOrNull(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
