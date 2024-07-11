import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
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
    GetPage(
      name: RoutesPaths.dispensersHome,
      page: () => const DispensersHomeScreen(),
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
      name: RoutesPaths.settingsHome,
      page: () => const SettingsHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.shopsHome,
      page: () => const ShopsHomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.lubricantsHome,
      page: () => const LubricantsHomeScreen(),
    ),
  ];

  static String get initialRoute => RoutesPaths.loadingHome;

  // Puedes agregar métodos de conveniencia para la navegación
  static void goToUsers() => Get.toNamed(RoutesPaths.userHome);
  static void goToLogin() => Get.toNamed(RoutesPaths.loginHome);
  static void goToLicences() => Get.toNamed(RoutesPaths.licencesHome);
  static void goToDispensers() => Get.toNamed(RoutesPaths.dispensersHome);
  static void goToHome() => Get.toNamed(RoutesPaths.mainHome);
  static void goToSales() => Get.toNamed(RoutesPaths.salesHome);
  static void goToSettings() => Get.toNamed(RoutesPaths.settingsHome);
  static void goToShops() => Get.toNamed(RoutesPaths.shopsHome);
  static void goToLubricants() => Get.toNamed(RoutesPaths.lubricantsHome);
}
