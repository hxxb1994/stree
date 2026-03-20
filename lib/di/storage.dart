import 'package:get_it/get_it.dart';

import '../data/local/local.dart';

Future<void> setupStorage() async {
  final storage = SharedPrefsStorage();
  await storage.init();

  GetIt.I.registerSingleton<LocalStorage>(storage);
}
