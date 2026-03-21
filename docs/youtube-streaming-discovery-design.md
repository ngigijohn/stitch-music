# YouTube Streaming Discovery Design (Policy-Compliant)

Last updated: 2026-03-21
Owner: Stitch Music team
Status: Discovery + architecture scaffolded + read-only UI demo

## Objective

Add YouTube as a discovery/playback source only through policy-compliant, licensed, official API pathways.

## Non-Goals

- No scraping watch pages for media URLs.
- No signature deciphering.
- No reverse engineering private endpoints.
- No downloading/storing unlicensed media.

## Compliance Guardrails

1. Only official APIs and SDKs permitted by terms.
2. User authentication and consent required where applicable.
3. Playback enabled only when entitlement checks pass.
4. Region and content restrictions must be respected.
5. Adapter must fail closed (no playback) when configuration or entitlement is missing.

## Product Requirements

1. Search remote catalog from in-app search entry point.
2. Show playable vs non-playable status per result.
3. Allow queue insertion for only resolvable/entitled items.
4. Show actionable error states:
   - sign in required
   - premium required
   - region restricted
   - unavailable
5. Keep local library behavior unchanged.

## Architecture

### Core interfaces

- `StreamSourceAdapter`
  - `search(StreamDiscoveryRequest)`
  - `resolvePlaybackUri(candidate, entitlement)`
  - `canPlay(candidate, entitlement)`

### Models

- `StreamDiscoveryRequest`
- `StreamCandidate`
- `StreamDiscoveryResult`
- `DiscoveryError`
- `UserEntitlement`

### Registry

- `StreamAdapterRegistry` selects adapter by provider (`youtube`, future providers).

### Current scaffold

- `YouTubeCompliantDiscoveryAdapter`
   - Routes discovery and playback resolution through a backend gateway boundary.
   - In production-safe mode, returns explicit not-configured errors until official API auth is wired.
   - Playback intentionally returns `null` and `false` without compliant backend support.
- `NoopStreamBackendGateway`
   - Fail-closed default for production-safe mode.
- `MockYouTubeBackendGateway`
   - Returns demo entitlement + mock catalog results for UI testing only.
- `OnlineSearchScreen`
   - Read-only discovery UI with entitlement banners and demo/prod-safe mode toggle.

## Runtime Flow (target)

1. UI submits query to provider adapter.
2. Adapter returns candidates + provider metadata.
3. App evaluates `canPlay` with current entitlement.
4. On play request, app resolves playback URI via adapter.
5. If URI is null: show policy/entitlement error and block playback.
6. If URI exists: enqueue to player pipeline.

## Data & Privacy

1. Store only minimal metadata needed for UX (id/title/artist/provider).
2. Do not store provider tokens in plaintext.
3. Keep token lifecycle bounded and revocable.

## Risks

1. API policy changes may affect allowed playback paths.
2. Entitlement complexity differs by region/account type.
3. Playback URL expiration requires short-lived resolution strategy.

## Milestones

1. Discovery hardening
   - confirm exact official API scope and terms
   - finalize auth flow and entitlement checks
2. Read-only search UI
   - show remote results and playability state
   - status: shipped with mock/demo backend support
3. Controlled playback pilot
   - gated to entitled users only
4. Compliance review
   - checklist signoff before broad release

## Open Questions

1. Which official API product tier is appropriate for this app scale?
2. What minimum account state is required for legal playback in-app?
3. Do we need a backend token broker, or can client-only auth satisfy policy and security?

## Implementation Notes

The following scaffold files have been added:

- `lib/services/streaming/stream_discovery_models.dart`
- `lib/services/streaming/stream_backend_gateway.dart`
- `lib/services/streaming/stream_mock_backend_gateway.dart`
- `lib/services/streaming/stream_source_adapter.dart`
- `lib/services/streaming/youtube_compliant_discovery_adapter.dart`
- `lib/services/streaming/stream_adapter_registry.dart`
- `lib/screens/online_search_screen.dart`
