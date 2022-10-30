import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static late final Box _storage;

  static Future<void> init() async {
    await Hive.initFlutter();
    _storage = await Hive.openBox('care_why_app');
  }

  static Future<void> delete(LocalStorageKey key) async {
    return await _storage.delete(key.value);
  }

  static Future<void> set(LocalStorageKey key, String value) async {
    return await _storage.put(key.value, value);
  }

  static Future<String?> get(LocalStorageKey key) async {
    return await _storage.get(key.value);
  }
}

enum LocalStorageKey {
  token('token');

  const LocalStorageKey(this.value);
  final String value;
}
