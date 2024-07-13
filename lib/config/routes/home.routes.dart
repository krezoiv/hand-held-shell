import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';

import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';

class HomeRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.mainHome,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: RoutesPaths.loadingHome,
      page: () => const LoadingScreen(),
      binding: BindingsBuilder(() {
        Get.put(AuthService());
        Get.put(SocketService());
      }),
    ),
  ];
  static void goToHome() => Get.toNamed(RoutesPaths.mainHome);
  static String get initialRoute => RoutesPaths.loadingHome;
}
