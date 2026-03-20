import 'package:get_it/get_it.dart';

import '../data/repository/repository.dart';

final getIt = GetIt.instance;

void setupRepository() {
  // -------- Repository --------
  getIt.registerLazySingleton(() => UserRepository(getIt()));
  getIt.registerLazySingleton(() => LocalRepository(getIt()));
}
