abstract class LocalStorage {
  Future<void> init();

  String? getString(String key);
  bool? getBool(String key);

  Future<void> setString(String key, String value);
  Future<void> setBool(String key, bool value);

  Future<void> remove(String key);
  Future<void> clear();
}
