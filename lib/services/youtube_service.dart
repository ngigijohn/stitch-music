import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/music_models.dart';

/// Thin wrapper around the YouTube Data API v3 search endpoint.
///
/// Requires a valid [apiKey] obtained from the Google Cloud Console with the
/// "YouTube Data API v3" service enabled. All requests use HTTPS and the
/// official Google API endpoint — no unlicensed extraction is performed.
class YouTubeService {
  static const String _baseUrl =
      'https://www.googleapis.com/youtube/v3/search';

  /// Search for music videos on YouTube.
  ///
  /// Returns up to [maxResults] (default 25) [YouTubeVideoResult] objects.
  /// Throws a [YouTubeServiceException] on network or API errors.
  static Future<List<YouTubeVideoResult>> searchMusic(
    String query,
    String apiKey, {
    int maxResults = 25,
  }) async {
    if (query.trim().isEmpty) return const [];
    if (apiKey.trim().isEmpty) {
      throw const YouTubeServiceException(
          'No YouTube API key configured. Add your key in Settings.');
    }

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'part': 'snippet',
      'q': query.trim(),
      'type': 'video',
      'videoCategoryId': '10', // Music
      'maxResults': '$maxResults',
      'key': apiKey.trim(),
    });

    final http.Response response;
    try {
      response = await http.get(uri).timeout(const Duration(seconds: 15));
    } catch (e) {
      throw YouTubeServiceException('Network error: $e');
    }

    if (response.statusCode != 200) {
      String reason = '';
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        reason = ((body['error'] as Map?)?['message'] ?? '').toString();
      } catch (_) {}
      throw YouTubeServiceException(
          'YouTube API error ${response.statusCode}${reason.isNotEmpty ? ": $reason" : ""}');
    }

    final Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw YouTubeServiceException('Failed to parse response: $e');
    }

    final items = (body['items'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(YouTubeVideoResult.fromJson)
        .where((r) => r.videoId.isNotEmpty)
        .toList();

    return items;
  }
}

class YouTubeServiceException implements Exception {
  final String message;
  const YouTubeServiceException(this.message);

  @override
  String toString() => 'YouTubeServiceException: $message';
}
