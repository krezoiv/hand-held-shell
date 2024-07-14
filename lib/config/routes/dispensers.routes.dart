import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/views/screens.exports.files.dart';

class DispensersRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.dispensersHome,
      page: () => const DispensersHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.newRegisterDispenserScreen,
      page: () => NewRegisterDispenserScreen(),
    ),
    GetPage(
      name: RoutesPaths.modifyRegisterDispenserScreen,
      page: () => const ModifyRegisterDispenserScreen(),
    ),
    GetPage(
      name: RoutesPaths.deleteRegisterDispenserScreen,
      page: () => const DeleteRegisterDispensersScreen(),
    ),
    GetPage(
      name: RoutesPaths.deleteAllRegisterDispenserScreen,
      page: () => const DeleteAllRegisterDispenserScreen(),
    ),
  ];
  static void goToDispensers() => Get.toNamed(RoutesPaths.dispensersHome);
  static void goToNewRegisterDispenser() =>
      Get.toNamed(RoutesPaths.newRegisterDispenserScreen);
  static void goToModifyRegisterDispenser() =>
      Get.toNamed(RoutesPaths.modifyRegisterDispenserScreen);
  static void goToDeleteRegisterDispenser() =>
      Get.toNamed(RoutesPaths.deleteRegisterDispenserScreen);
  static void goToDeleteAllRegisterDispenser() =>
      Get.toNamed(RoutesPaths.deleteAllRegisterDispenserScreen);
}
