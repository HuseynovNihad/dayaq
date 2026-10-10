import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage({required this._secureStorage});

  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'dayaq_access_token';
  static const _userEmailKey = 'dayaq_user_email';

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveEmail(String email) async {
    await _secureStorage.write(key: _userEmailKey, value: email.trim());
  }

  Future<String?> getEmail() async {
    return _secureStorage.read(key: _userEmailKey);
  }

  Future<void> deleteEmail() async {
    await _secureStorage.delete(key: _userEmailKey);
  }

  Future<void> clearSession() async {
    await deleteToken();
    await deleteEmail();
  }
}
