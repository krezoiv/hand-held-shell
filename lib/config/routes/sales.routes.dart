import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

class SalesRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.salesHome,
      page: () => const SalesHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.newSales,
      page: () => const NewSalesScreen(),
    ),
    GetPage(
      name: RoutesPaths.modifySales,
      page: () => const ModifySalesScreen(),
    ),
    GetPage(
      name: RoutesPaths.deleteSales,
      page: () => const DeleteSalesScreen(),
    ),
    GetPage(
      name: RoutesPaths.searchSales,
      page: () => const SearchSalesScreen(),
    ),
  ];
  static void goToSales() => Get.toNamed(RoutesPaths.salesHome);
  static void goToNewSale() => Get.toNamed(RoutesPaths.newSales);
  static void goToModifySale() => Get.toNamed(RoutesPaths.modifySales);
  static void goToDeleteSale() => Get.toNamed(RoutesPaths.deleteSales);
  static void goToSearchSale() => Get.toNamed(RoutesPaths.searchSales);
}
