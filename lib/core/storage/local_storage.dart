/// Technology-agnostic key-value storage contract.
///
/// UI and features depend on this interface, never on SharedPreferences/Hive.
abstract interface class LocalStorage {
  Future<void> init();

  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);

  Future<bool?> getBool(String key);
  Future<void> setBool(String key, bool value);

  Future<int?> getInt(String key);
  Future<void> setInt(String key, int value);

  Future<void> clear();
  Future<bool> containsKey(String key);
}

/// In-memory stub for development and tests.
final class InMemoryLocalStorage implements LocalStorage {
  InMemoryLocalStorage();

  final Map<String, Object> _store = {};

  @override
  Future<void> init() async {}

  @override
  Future<String?> getString(String key) async {
    final value = _store[key];
    return value is String ? value : null;
  }

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<bool?> getBool(String key) async {
    final value = _store[key];
    return value is bool ? value : null;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    _store[key] = value;
  }

  @override
  Future<int?> getInt(String key) async {
    final value = _store[key];
    return value is int ? value : null;
  }

  @override
  Future<void> setInt(String key, int value) async {
    _store[key] = value;
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _store.containsKey(key);
  }
}
