import 'package:base_provider/base_provider.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import 'api.dart';
import 'controller.dart';
import 'repository.dart';
import 'storage.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  // -------- Network --------
  getIt.registerLazySingleton<NetworkChecker>(
    () => ConnectivityNetworkChecker(),
  );

  getIt.registerLazySingleton(
    () => NetworkClient(baseUrl: AppConfig.baseUrl, networkChecker: getIt()),
  );
  // Setup API
  setupAPI();
  // Setup Repository
  setupRepository();
  // Setup Controller
  setupController();
  // setup Local Storage
  setupStorage();
}
