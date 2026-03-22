import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/services/streaming/stream_discovery_models.dart';
import 'package:stitch_music/services/streaming/stream_mock_backend_gateway.dart';

void main() {
  test('mock backend resolves playback URI for entitled candidate', () async {
    const gateway = MockYouTubeBackendGateway();
    const entitlement = UserEntitlement(
      authenticated: true,
      hasPremium: true,
      regionAllowed: true,
      providerUserId: 'demo-user',
    );
    const candidate = StreamCandidate(
      id: 'demo123',
      title: 'Demo Track',
      artist: 'Demo Artist',
      provider: 'youtube',
      requiresEntitlement: true,
    );

    final uri = await gateway.resolvePlaybackUri(
      provider: 'youtube',
      candidate: candidate,
      entitlement: entitlement,
    );

    expect(uri, isNotNull);
    expect(uri.toString(), contains('demo123'));
  });

  test('mock backend fails closed when not entitled', () async {
    const gateway = MockYouTubeBackendGateway();
    const entitlement = UserEntitlement(
      authenticated: false,
      hasPremium: false,
      regionAllowed: false,
      providerUserId: '',
    );
    const candidate = StreamCandidate(
      id: 'demo123',
      title: 'Demo Track',
      artist: 'Demo Artist',
      provider: 'youtube',
      requiresEntitlement: true,
    );

    final uri = await gateway.resolvePlaybackUri(
      provider: 'youtube',
      candidate: candidate,
      entitlement: entitlement,
    );

    expect(uri, isNull);
  });
}
