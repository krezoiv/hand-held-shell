import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/chat.controller.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';
import 'package:hand_held_shell/controllers/user.controller.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/screens/lubricants/presentation/screens/lubricants.home.screen.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';
import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.userHome,
      page: () => const UserHomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(UserController());
      }),
    ),
    GetPage(
      name: RoutesPaths.chatHome,
      page: () => const ChatScreen(),
      binding: BindingsBuilder(() {
        Get.put(ChatController());
      }),
    ),
    GetPage(
      name: RoutesPaths.loadingHome,
      page: () => const LoadingScreen(),
      binding: BindingsBuilder(() {
        Get.put(AuthService());
        Get.put(SocketService());
      }),
    ),
    GetPage(
      name: RoutesPaths.loginHome,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: RoutesPaths.licencesHome,
      page: () => const LicencesScreen(),
    ),
    // Dispensers
    GetPage(
      name: RoutesPaths.dispensersHome,
      page: () => const DispensersHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.newRegisterDispenserScreen,
      page: () => const NewRegisterDispenserScreen(),
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
    GetPage(
      name: RoutesPaths.mainHome,
      page: () => const HomeScreen(),
    ),
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
    GetPage(
      name: RoutesPaths.settingsHome,
      page: () => const SettingsHomeScreen(),
    ),

    GetPage(
      name: RoutesPaths.changePriceScreen,
      page: () => const ChangePriceScreen(),
    ),

    GetPage(
      name: RoutesPaths.changePassScreen,
      page: () => const ChangePasswordScreen(),
    ),

    GetPage(
      name: RoutesPaths.changeThemeScreen,
      page: () => ChangeThemeScreen(),
    ),

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

  static String get initialRoute => RoutesPaths.loadingHome;

  // Métodos de conveniencia para la navegación
  static void goToChat() => Get.toNamed(RoutesPaths.chatHome);
  static void goToUsers() => Get.toNamed(RoutesPaths.userHome);
  static void goToLogin() => Get.toNamed(RoutesPaths.loginHome);
  static void goToLicences() => Get.toNamed(RoutesPaths.licencesHome);

  //dispensers paths
  static void goToDispensers() => Get.toNamed(RoutesPaths.dispensersHome);
  static void goToNewRegisterDispenser() =>
      Get.toNamed(RoutesPaths.newRegisterDispenserScreen);
  static void goToModifyRegisterDispenser() =>
      Get.toNamed(RoutesPaths.modifyRegisterDispenserScreen);
  static void goToDeleteRegisterDispenser() =>
      Get.toNamed(RoutesPaths.deleteRegisterDispenserScreen);
  static void goToDeleteAllRegisterDispenser() =>
      Get.toNamed(RoutesPaths.deleteAllRegisterDispenserScreen);

  static void goToHome() => Get.toNamed(RoutesPaths.mainHome);

  //sales
  static void goToSales() => Get.toNamed(RoutesPaths.salesHome);
  static void goToNewSale() => Get.toNamed(RoutesPaths.newSales);
  static void goToModifySale() => Get.toNamed(RoutesPaths.modifySales);
  static void goToDeleteSale() => Get.toNamed(RoutesPaths.deleteSales);
  static void goToSearchSale() => Get.toNamed(RoutesPaths.searchSales);

  static void goToSettings() => Get.toNamed(RoutesPaths.settingsHome);
  static void goToChangePrice() => Get.toNamed(RoutesPaths.changePriceScreen);
  static void goToChangePassword() => Get.toNamed(RoutesPaths.changePassScreen);
  static void goToChangeTheme() => Get.toNamed(RoutesPaths.changeThemeScreen);

  //shops
  static void goToShops() => Get.toNamed(RoutesPaths.shopsHome);
  static void goToDeleteOrderShop() =>
      Get.toNamed(RoutesPaths.deleteOrderShopScreen);
  static void goToDeleteShop() => Get.toNamed(RoutesPaths.deleteShopScreen);
  static void goToModifyOrderShop() =>
      Get.toNamed(RoutesPaths.modifyOrderShopScreen);
  static void goToModifyShop() => Get.toNamed(RoutesPaths.modifyShopScreen);
  static void goToNewOrderShop() => Get.toNamed(RoutesPaths.newOrderShopScreen);
  static void goToNewShops() => Get.toNamed(RoutesPaths.newShopScreen);

  //lubricants
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
