import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _access  = 'access_token';
  static const _refresh = 'refresh_token';

  final _storage = const FlutterSecureStorage();

  Future<String?> getAccessToken()  => _storage.read(key: _access);
  Future<String?> getRefreshToken() => _storage.read(key: _refresh);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _access,  value: accessToken);
    await _storage.write(key: _refresh, value: refreshToken);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
