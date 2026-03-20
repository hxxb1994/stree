import 'package:base_provider/base_provider.dart';

import '../model/model.dart';

class UserApi extends BaseApiService {
  UserApi(super.client);

  Future<User> getData() {
    Log.d('UserApi - getData');
    return requestObject(
      path: '/gets',
      method: Method.get,
      parser: User.fromJson,
    );
  }

  Future<bool> getOnLed() {
    return requestObject(
      path: '/on-led',
      method: Method.get,
      parser: (data) => data["status"],
    );
  }

  Future<bool> getOffLed() {
    return requestObject(
      path: '/off-led',
      method: Method.get,
      parser: (data) => data["status"],
    );
  }

  Future<bool> getOnWatter() {
    return requestObject(
      path: '/on-watter',
      method: Method.get,
      parser: (data) => data["status"],
    );
  }

  Future<bool> getOffWatter() {
    return requestObject(
      path: '/off-watter',
      method: Method.get,
      parser: (data) => data["status"],
    );
  }
}
