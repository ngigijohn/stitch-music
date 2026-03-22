import 'dart:convert';
import 'dart:io';

class StreamHttpResponse {
  final int statusCode;
  final Map<String, dynamic>? jsonBody;

  const StreamHttpResponse({
    required this.statusCode,
    this.jsonBody,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}

abstract class StreamHttpTransport {
  Future<StreamHttpResponse> getJson({
    required Uri uri,
    Map<String, String> headers = const {},
  });

  Future<StreamHttpResponse> postJson({
    required Uri uri,
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  });
}

class NoopStreamHttpTransport implements StreamHttpTransport {
  const NoopStreamHttpTransport();

  @override
  Future<StreamHttpResponse> getJson({
    required Uri uri,
    Map<String, String> headers = const {},
  }) async {
    return const StreamHttpResponse(statusCode: 503);
  }

  @override
  Future<StreamHttpResponse> postJson({
    required Uri uri,
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    return const StreamHttpResponse(statusCode: 503);
  }
}

class DartIoStreamHttpTransport implements StreamHttpTransport {
  const DartIoStreamHttpTransport();

  @override
  Future<StreamHttpResponse> getJson({
    required Uri uri,
    Map<String, String> headers = const {},
  }) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      headers.forEach(request.headers.set);
      request.headers.contentType = ContentType.json;
      final response = await request.close();
      final raw = await response.transform(utf8.decoder).join();
      final dynamic decoded = raw.isEmpty ? null : jsonDecode(raw);
      return StreamHttpResponse(
        statusCode: response.statusCode,
        jsonBody: decoded is Map<String, dynamic> ? decoded : null,
      );
    } catch (_) {
      return const StreamHttpResponse(statusCode: 500);
    } finally {
      client.close(force: true);
    }
  }

  @override
  Future<StreamHttpResponse> postJson({
    required Uri uri,
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(uri);
      headers.forEach(request.headers.set);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
      final response = await request.close();
      final raw = await response.transform(utf8.decoder).join();
      final dynamic decoded = raw.isEmpty ? null : jsonDecode(raw);
      return StreamHttpResponse(
        statusCode: response.statusCode,
        jsonBody: decoded is Map<String, dynamic> ? decoded : null,
      );
    } catch (_) {
      return const StreamHttpResponse(statusCode: 500);
    } finally {
      client.close(force: true);
    }
  }
}
