import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

class LubricantsRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.lubricantsHome,
      page: () => const LubricantsHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.deleteShopLubricant,
      page: () => const DeleteShopLubricantScreen(),
    ),
    GetPage(
      name: RoutesPaths.modifyShopLubricant,
      page: () => const ModifyShopLubricantScreen(),
    ),
    GetPage(
      name: RoutesPaths.newShopLubricants,
      page: () => const NewShopLubricantScreen(),
    ),
    GetPage(
      name: RoutesPaths.searchShopLubricant,
      page: () => const SearchShopLubricantScreen(),
    ),
  ];
  static void goToLubricants() => Get.toNamed(RoutesPaths.lubricantsHome);
  static void goToDeleteShopLubricant() =>
      Get.toNamed(RoutesPaths.deleteShopLubricant);
  static void goToModifyShopLubricant() =>
      Get.toNamed(RoutesPaths.modifyShopLubricant);
  static void goToNewShopLubricant() =>
      Get.toNamed(RoutesPaths.newShopLubricants);
  static void goToSearchShopLubricant() =>
      Get.toNamed(RoutesPaths.searchShopLubricant);
}
