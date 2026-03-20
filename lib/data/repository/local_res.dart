import '../../config/config.dart';
import '../local/local.dart';

class LocalRepository {
  final LocalStorage _storage;

  LocalRepository(this._storage);

  bool isLoggedIn() {
    return _storage.getString(StorageKeys.accessToken) != null;
  }

  bool isFirstLaunch() {
    return _storage.getString(StorageKeys.isFirstLaunch) == null;
  }

  Future<void> saveToken(String token) async {
    await _storage.setString(StorageKeys.accessToken, token);
  }

  Future<void> logout() async {
    await _storage.remove(StorageKeys.accessToken);
  }
}
