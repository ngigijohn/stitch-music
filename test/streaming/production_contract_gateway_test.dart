import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/services/streaming/stream_auth_service.dart';
import 'package:stitch_music/services/streaming/stream_backend_gateway.dart';
import 'package:stitch_music/services/streaming/stream_discovery_models.dart';
import 'package:stitch_music/services/streaming/stream_http_transport.dart';

class _FakeTransport implements StreamHttpTransport {
  final Map<String, StreamHttpResponse> getResponses;
  final Map<String, StreamHttpResponse> postResponses;

  _FakeTransport({
    this.getResponses = const {},
    this.postResponses = const {},
  });

  @override
  Future<StreamHttpResponse> getJson({required Uri uri, Map<String, String> headers = const {}}) async {
    return getResponses[uri.toString()] ?? const StreamHttpResponse(statusCode: 404);
  }

  @override
  Future<StreamHttpResponse> postJson({
    required Uri uri,
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    return postResponses[uri.toString()] ?? const StreamHttpResponse(statusCode: 404);
  }
}

void main() {
  final contracts = {
    'youtube': ProviderBackendContract(
      entitlementEndpoint: Uri.parse('https://api.example.test/entitlement'),
      catalogEndpoint: Uri.parse('https://api.example.test/catalog'),
      playbackResolveEndpoint: Uri.parse('https://api.example.test/resolve'),
      staticHeaders: const {'X-Contract': 'phase4-test'},
    ),
  };

  InMemoryStreamAuthService buildSignedInAuth() {
    return InMemoryStreamAuthService(
      seedSessions: {
        'youtube': StreamAuthSession(
          provider: 'youtube',
          providerUserId: 'provider-user-1',
          accessToken: 'token-abc',
          refreshToken: 'refresh-abc',
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
        ),
      },
    );
  }

  test('production gateway fails closed when contract is missing', () async {
    final gateway = ProductionContractStreamBackendGateway(
      providerContracts: const {},
      authService: buildSignedInAuth(),
      httpTransport: _FakeTransport(),
    );

    final entitlement = await gateway.fetchEntitlement(provider: 'youtube');
    expect(entitlement.canAttemptPlayback, isFalse);

    final search = await gateway.searchCatalog(
      provider: 'youtube',
      request: const StreamDiscoveryRequest(query: 'test'),
    );
    expect(search.error, isNotNull);

    final uri = await gateway.resolvePlaybackUri(
      provider: 'youtube',
      candidate: const StreamCandidate(
        id: '1',
        title: 'x',
        artist: 'y',
        provider: 'youtube',
      ),
      entitlement: entitlement,
    );
    expect(uri, isNull);
  });

  test('production gateway uses configured endpoints for entitlement/search/resolve', () async {
    final transport = _FakeTransport(
      getResponses: {
        'https://api.example.test/entitlement': const StreamHttpResponse(
          statusCode: 200,
          jsonBody: {
            'authenticated': true,
            'hasPremium': true,
            'regionAllowed': true,
            'providerUserId': 'provider-user-1',
            'statusMessage': 'Entitled by backend',
          },
        ),
      },
      postResponses: {
        'https://api.example.test/catalog': const StreamHttpResponse(
          statusCode: 200,
          jsonBody: {
            'candidates': [
              {
                'id': 'yt-123',
                'title': 'Backend Track',
                'artist': 'Backend Artist',
                'provider': 'youtube',
                'durationSeconds': 245,
                'requiresEntitlement': true,
              },
            ],
          },
        ),
        'https://api.example.test/resolve': const StreamHttpResponse(
          statusCode: 200,
          jsonBody: {
            'playbackUri': 'https://cdn.example.test/yt-123.mp3',
          },
        ),
      },
    );

    final gateway = ProductionContractStreamBackendGateway(
      providerContracts: contracts,
      authService: buildSignedInAuth(),
      httpTransport: transport,
    );

    final entitlement = await gateway.fetchEntitlement(provider: 'youtube');
    expect(entitlement.canAttemptPlayback, isTrue);

    final search = await gateway.searchCatalog(
      provider: 'youtube',
      request: const StreamDiscoveryRequest(query: 'backend song'),
    );
    expect(search.error, isNull);
    expect(search.candidates, isNotEmpty);
    expect(search.candidates.first.id, 'yt-123');

    final resolved = await gateway.resolvePlaybackUri(
      provider: 'youtube',
      candidate: search.candidates.first,
      entitlement: entitlement,
    );
    expect(resolved, isNotNull);
    expect(resolved.toString(), 'https://cdn.example.test/yt-123.mp3');
  });

  test('production gateway stays fail-closed when entitlement response denies premium', () async {
    final transport = _FakeTransport(
      getResponses: {
        'https://api.example.test/entitlement': const StreamHttpResponse(
          statusCode: 200,
          jsonBody: {
            'authenticated': true,
            'hasPremium': false,
            'regionAllowed': true,
            'providerUserId': 'provider-user-1',
          },
        ),
      },
      postResponses: {
        'https://api.example.test/resolve': const StreamHttpResponse(
          statusCode: 200,
          jsonBody: {
            'playbackUri': 'https://cdn.example.test/denied.mp3',
          },
        ),
      },
    );

    final gateway = ProductionContractStreamBackendGateway(
      providerContracts: contracts,
      authService: buildSignedInAuth(),
      httpTransport: transport,
    );

    final entitlement = await gateway.fetchEntitlement(provider: 'youtube');
    expect(entitlement.canAttemptPlayback, isFalse);

    final uri = await gateway.resolvePlaybackUri(
      provider: 'youtube',
      candidate: const StreamCandidate(
        id: 'yt-denied',
        title: 'Denied Track',
        artist: 'Denied Artist',
        provider: 'youtube',
      ),
      entitlement: entitlement,
    );

    expect(uri, isNull);
  });
}
