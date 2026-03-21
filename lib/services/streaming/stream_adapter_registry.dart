import 'stream_source_adapter.dart';
import 'youtube_compliant_discovery_adapter.dart';

class StreamAdapterRegistry {
  final Map<String, StreamSourceAdapter> _adapters;

  StreamAdapterRegistry._(this._adapters);

  factory StreamAdapterRegistry.defaultRegistry() {
    final adapters = <String, StreamSourceAdapter>{
      'youtube': YouTubeCompliantDiscoveryAdapter(),
    };
    return StreamAdapterRegistry._(adapters);
  }

  StreamSourceAdapter? byProvider(String provider) => _adapters[provider];

  List<String> providers() => _adapters.keys.toList(growable: false);
}
