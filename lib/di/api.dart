import 'package:get_it/get_it.dart';

import '../data/api/api.dart';

final getIt = GetIt.instance;

void setupAPI() {
  // -------- API --------
  getIt.registerLazySingleton(() => UserApi(getIt()));
}
