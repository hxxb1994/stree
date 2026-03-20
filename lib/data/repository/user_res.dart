import '../api/api.dart';
import '../model/model.dart';

class UserRepository {
  final UserApi _api;

  UserRepository(this._api);

  Future<User> getProfile() async {
    // Fetch user profile from API, handle caching or data transformation if needed
    return _api.getData();
  }

  Future<bool> onLed() async {
    return _api.getOnLed();
  }

  Future<bool> offLed() async {
    return _api.getOffLed();
  }

  Future<bool> onWatter() async {
    return _api.getOnWatter();
  }

  Future<bool> offWatter() async {
    return _api.getOffWatter();
  }
}
