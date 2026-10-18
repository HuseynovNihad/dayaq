import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted device-local drafts. Only call this while the relevant user is logged in.
/// For multi-account devices, supply a stable account identifier as [ownerId].
class RegistrationDraftStorage {
  RegistrationDraftStorage._();
  static const _storage = FlutterSecureStorage();

  static String _key(String ownerId) => 'dayaq.registration_drafts.v1.${base64Url.encode(utf8.encode(ownerId.trim().toLowerCase()))}';

  static Future<List<Map<String, dynamic>>> load(String ownerId) async {
    final raw = await _storage.read(key: _key(ownerId));
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<void> upsert(String ownerId, Map<String, dynamic> draft) async {
    if (ownerId.trim().isEmpty) throw const FormatException('İstifadəçi müəyyən edilməyib.');
    final items = await load(ownerId);
    items.removeWhere((item) => item['id'] == draft['id']);
    items.insert(0, draft);
    await _storage.write(key: _key(ownerId), value: jsonEncode(items));
  }

  static Future<void> delete(String ownerId, String id) async {
    final items = await load(ownerId);
    items.removeWhere((item) => item['id'] == id);
    await _storage.write(key: _key(ownerId), value: jsonEncode(items));
  }
}
