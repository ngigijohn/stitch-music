class StreamDiscoveryRequest {
  final String query;
  final String regionCode;
  final bool explicitAllowed;

  const StreamDiscoveryRequest({
    required this.query,
    this.regionCode = 'US',
    this.explicitAllowed = true,
  });
}

class StreamCandidate {
  final String id;
  final String title;
  final String artist;
  final String provider;
  final Uri? playbackUri;
  final Duration? duration;
  final bool requiresEntitlement;

  const StreamCandidate({
    required this.id,
    required this.title,
    required this.artist,
    required this.provider,
    this.playbackUri,
    this.duration,
    this.requiresEntitlement = true,
  });
}

class DiscoveryError {
  final String code;
  final String message;
  final bool userActionable;

  const DiscoveryError({
    required this.code,
    required this.message,
    this.userActionable = false,
  });
}

class StreamDiscoveryResult {
  final List<StreamCandidate> candidates;
  final DiscoveryError? error;

  const StreamDiscoveryResult({
    this.candidates = const [],
    this.error,
  });

  bool get isSuccess => error == null;
}

class UserEntitlement {
  final bool authenticated;
  final bool hasPremium;
  final bool regionAllowed;
  final String providerUserId;
  final String? statusMessage;

  const UserEntitlement({
    required this.authenticated,
    required this.hasPremium,
    this.regionAllowed = true,
    required this.providerUserId,
    this.statusMessage,
  });

  bool get canAttemptPlayback => authenticated && hasPremium && regionAllowed;
}

class StreamAuthSession {
  final String provider;
  final String providerUserId;
  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  const StreamAuthSession({
    required this.provider,
    required this.providerUserId,
    required this.accessToken,
    this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
