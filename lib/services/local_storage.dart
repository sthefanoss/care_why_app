import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert' as convert;

class LocalStorage {
  static late final Box _storage;

  static Future<void> init() async {
    await Hive.initFlutter();
    _storage = await Hive.openBox('care_why_app');
  }

  Future<void> delete(String key) {
    return _storage.delete(key);
  }

  Future<void> saveMap(String key, Map<String, dynamic> value) {
    return _storage.put(key, convert.jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getMap(String key) async {
    final data = await _storage.get(key);
    if (data == null) {
      return null;
    }
    return convert.jsonDecode(data);
  }

  Future<void> saveObject<T>(
    String key,
    T object, {
    required Map<String, dynamic> Function(T object) encoder,
  }) {
    return saveMap(key, encoder(object));
  }

  Future<T?> getObject<T>(
    String key, {
    required T Function(Map<String, dynamic> object) decoder,
  }) async {
    final data = await getMap(key);
    if (data == null) {
      return null;
    }
    return decoder(data);
  }
}
