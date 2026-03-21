import 'stream_discovery_models.dart';

abstract class StreamSourceAdapter {
  String get provider;

  Future<StreamDiscoveryResult> search(StreamDiscoveryRequest request);

  Future<Uri?> resolvePlaybackUri({
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  });

  Future<bool> canPlay({
    required StreamCandidate candidate,
    required UserEntitlement entitlement,
  });
}
