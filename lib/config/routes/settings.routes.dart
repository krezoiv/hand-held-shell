import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

class SettingsRoutes {
  static final routes = [
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
      name: RoutesPaths.licencesHome,
      page: () => const LicencesScreen(),
    ),
  ];
  static void goToSettings() => Get.toNamed(RoutesPaths.settingsHome);
  static void goToChangePrice() => Get.toNamed(RoutesPaths.changePriceScreen);
  static void goToChangePassword() => Get.toNamed(RoutesPaths.changePassScreen);
  static void goToChangeTheme() => Get.toNamed(RoutesPaths.changeThemeScreen);
  static void goToLicences() => Get.toNamed(RoutesPaths.licencesHome);
}
