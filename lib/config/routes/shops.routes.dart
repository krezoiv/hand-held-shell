import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/views/screens.exports.files.dart';

class ShopsRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.shopsHome,
      page: () => const ShopsHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.newOrderShopScreen,
      page: () => const NewOrderShopsScreen(),
    ),
    GetPage(
      name: RoutesPaths.modifyOrderShopScreen,
      page: () => const ModifyOrderShopsScreen(),
    ),
    GetPage(
      name: RoutesPaths.deleteOrderShopScreen,
      page: () => const DeleteOrderShopsScreen(),
    ),
    GetPage(
      name: RoutesPaths.newShopScreen,
      page: () => const NewShopsScreen(),
    ),
    GetPage(
      name: RoutesPaths.modifyShopScreen,
      page: () => const ModifyShopsScreen(),
    ),
    GetPage(
      name: RoutesPaths.deleteShopScreen,
      page: () => const DeleteShopsScreen(),
    ),
  ];
  static void goToShops() => Get.toNamed(RoutesPaths.shopsHome);
  static void goToDeleteOrderShop() =>
      Get.toNamed(RoutesPaths.deleteOrderShopScreen);
  static void goToDeleteShop() => Get.toNamed(RoutesPaths.deleteShopScreen);
  static void goToModifyOrderShop() =>
      Get.toNamed(RoutesPaths.modifyOrderShopScreen);
  static void goToModifyShop() => Get.toNamed(RoutesPaths.modifyShopScreen);
  static void goToNewOrderShop() => Get.toNamed(RoutesPaths.newOrderShopScreen);
  static void goToNewShops() => Get.toNamed(RoutesPaths.newShopScreen);
}
