import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000';

  final http.Client _client;
  final TokenStorage _tokenStorage;

  ApiClient({http.Client? client, required TokenStorage tokenStorage})
      : _client = client ?? http.Client(),
        _tokenStorage = tokenStorage;

  Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  dynamic _parse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    if (response.statusCode == 401) throw UnauthorizedException();
    throw ApiException(response.statusCode, response.body);
  }

  Future<dynamic> _withRefresh(Future<http.Response> Function() request) async {
    var response = await request();
    if (response.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) response = await request();
    }
    return _parse(response);
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await _tokenStorage.saveTokens(
          accessToken: data['accessToken'].toString(),
          refreshToken: data['refreshToken'].toString(),
        );
        return true;
      }
    } catch (_) {}
    await _tokenStorage.clear();
    return false;
  }

  Future<dynamic> get(String path, {bool auth = true}) =>
      _withRefresh(() async => _client.get(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
      ));

  Future<dynamic> post(String path, {Object? body, bool auth = true}) =>
      _withRefresh(() async => _client.post(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      ));

  Future<dynamic> put(String path, {Object? body, bool auth = true}) =>
      _withRefresh(() async => _client.put(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
        body: body != null ? jsonEncode(body) : null,
      ));

  Future<dynamic> delete(String path, {bool auth = true}) =>
      _withRefresh(() async => _client.delete(
        Uri.parse('$baseUrl$path'),
        headers: await _headers(auth: auth),
      ));
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException implements Exception {}
