import 'stream_backend_gateway.dart';
import 'stream_mock_backend_gateway.dart';
import 'stream_source_adapter.dart';
import 'youtube_compliant_discovery_adapter.dart';

class StreamAdapterRegistry {
  final Map<String, StreamSourceAdapter> _adapters;

  StreamAdapterRegistry._(this._adapters);

  factory StreamAdapterRegistry.defaultRegistry({StreamBackendGateway? gateway}) {
    final StreamBackendGateway effectiveGateway = gateway ??
        const ProductionContractStreamBackendGateway(
          providerContracts: {
            'youtube': ProviderBackendContract(),
          },
        );
    final adapters = <String, StreamSourceAdapter>{
      'youtube': YouTubeCompliantDiscoveryAdapter(gateway: effectiveGateway),
    };
    return StreamAdapterRegistry._(adapters);
  }

  factory StreamAdapterRegistry.demoRegistry() {
    return StreamAdapterRegistry.defaultRegistry(gateway: MockYouTubeBackendGateway());
  }

  StreamSourceAdapter? byProvider(String provider) => _adapters[provider];

  List<String> providers() => _adapters.keys.toList(growable: false);
}
