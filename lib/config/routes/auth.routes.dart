import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';

import 'package:hand_held_shell/views/screens.exports.files.dart';

class AuthRoutes {
  static final routes = [
    GetPage(
      name: RoutesPaths.loginHome,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
  ];

  static void goToLogin() => Get.toNamed(RoutesPaths.loginHome);
}
