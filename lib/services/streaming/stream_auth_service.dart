import 'stream_discovery_models.dart';

enum StreamAuthStatus {
  signedOut,
  signedIn,
  expired,
}

class StreamAuthState {
  final StreamAuthStatus status;
  final StreamAuthSession? session;
  final String? message;

  const StreamAuthState({
    required this.status,
    this.session,
    this.message,
  });

  bool get canCallEntitledApis => status == StreamAuthStatus.signedIn && session != null;
}

abstract class StreamAuthService {
  Future<StreamAuthState> currentState({required String provider});

  Future<StreamAuthState> refreshState({required String provider});
}

class NoopStreamAuthService implements StreamAuthService {
  const NoopStreamAuthService();

  @override
  Future<StreamAuthState> currentState({required String provider}) async {
    return const StreamAuthState(
      status: StreamAuthStatus.signedOut,
      message: 'Official sign-in is required before calling provider APIs.',
    );
  }

  @override
  Future<StreamAuthState> refreshState({required String provider}) async {
    return currentState(provider: provider);
  }
}

class InMemoryStreamAuthService implements StreamAuthService {
  final Map<String, StreamAuthSession> _sessions = <String, StreamAuthSession>{};

  InMemoryStreamAuthService({Map<String, StreamAuthSession>? seedSessions}) {
    if (seedSessions != null) {
      _sessions.addAll(seedSessions);
    }
  }

  @override
  Future<StreamAuthState> currentState({required String provider}) async {
    final session = _sessions[provider];
    if (session == null) {
      return const StreamAuthState(
        status: StreamAuthStatus.signedOut,
        message: 'No provider session is available.',
      );
    }

    if (session.isExpired) {
      return StreamAuthState(
        status: StreamAuthStatus.expired,
        session: session,
        message: 'Session expired. Refresh is required.',
      );
    }

    return StreamAuthState(
      status: StreamAuthStatus.signedIn,
      session: session,
    );
  }

  @override
  Future<StreamAuthState> refreshState({required String provider}) async {
    final state = await currentState(provider: provider);
    if (state.status != StreamAuthStatus.expired || state.session == null) {
      return state;
    }

    final expired = state.session!;
    if ((expired.refreshToken ?? '').isEmpty) {
      return StreamAuthState(
        status: StreamAuthStatus.expired,
        session: expired,
        message: 'Session expired and no refresh token is present.',
      );
    }

    final refreshed = StreamAuthSession(
      provider: expired.provider,
      providerUserId: expired.providerUserId,
      accessToken: '${expired.accessToken}_refreshed',
      refreshToken: expired.refreshToken,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
    _sessions[provider] = refreshed;

    return StreamAuthState(
      status: StreamAuthStatus.signedIn,
      session: refreshed,
      message: 'Session refreshed in-memory for integration testing.',
    );
  }

  Future<void> seedSession(StreamAuthSession session) async {
    _sessions[session.provider] = session;
  }

  Future<void> clearSession(String provider) async {
    _sessions.remove(provider);
  }
}
