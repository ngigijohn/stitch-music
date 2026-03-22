import 'package:flutter_test/flutter_test.dart';
import 'package:stitch_music/services/streaming/stream_auth_service.dart';
import 'package:stitch_music/services/streaming/stream_discovery_models.dart';

void main() {
  test('in-memory auth service transitions signedOut -> signedIn', () async {
    final auth = InMemoryStreamAuthService();

    final initial = await auth.currentState(provider: 'youtube');
    expect(initial.status, StreamAuthStatus.signedOut);

    await auth.seedSession(
      StreamAuthSession(
        provider: 'youtube',
        providerUserId: 'user-123',
        accessToken: 'token-a',
        refreshToken: 'refresh-a',
        expiresAt: DateTime.now().add(const Duration(minutes: 30)),
      ),
    );

    final afterSeed = await auth.currentState(provider: 'youtube');
    expect(afterSeed.status, StreamAuthStatus.signedIn);
    expect(afterSeed.session?.providerUserId, 'user-123');
  });

  test('in-memory auth refresh upgrades expired session when refresh token exists', () async {
    final auth = InMemoryStreamAuthService(
      seedSessions: {
        'youtube': StreamAuthSession(
          provider: 'youtube',
          providerUserId: 'user-321',
          accessToken: 'expired-token',
          refreshToken: 'refresh-token',
          expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      },
    );

    final before = await auth.currentState(provider: 'youtube');
    expect(before.status, StreamAuthStatus.expired);

    final refreshed = await auth.refreshState(provider: 'youtube');
    expect(refreshed.status, StreamAuthStatus.signedIn);
    expect(refreshed.session, isNotNull);
    expect(refreshed.session!.isExpired, isFalse);
    expect(refreshed.session!.accessToken, contains('refreshed'));
  });

  test('in-memory auth remains expired without refresh token', () async {
    final auth = InMemoryStreamAuthService(
      seedSessions: {
        'youtube': StreamAuthSession(
          provider: 'youtube',
          providerUserId: 'user-000',
          accessToken: 'expired-token',
          refreshToken: null,
          expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      },
    );

    final refreshed = await auth.refreshState(provider: 'youtube');
    expect(refreshed.status, StreamAuthStatus.expired);
    expect(refreshed.canCallEntitledApis, isFalse);
  });
}
