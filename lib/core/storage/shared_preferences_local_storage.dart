import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

/// [LocalStorage] backed by SharedPreferences for session persistence.
final class SharedPreferencesLocalStorage implements LocalStorage {
  SharedPreferencesLocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPreferencesLocalStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesLocalStorage(prefs);
  }

  @override
  Future<void> init() async {}

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async => _prefs.getInt(key);

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async => _prefs.containsKey(key);
}
