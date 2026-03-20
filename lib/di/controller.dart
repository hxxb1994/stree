import 'package:get_it/get_it.dart';
import 'package:water_mana/pages/home/home_controller.dart';

final getIt = GetIt.instance;

void setupController() {
  // -------- Controller --------
  getIt.registerFactory(() => HomeController());
}
