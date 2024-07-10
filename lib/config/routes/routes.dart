import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/chat.controller.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';
import 'package:hand_held_shell/controllers/user.controller.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/screens/screens.exports.files.dart';
import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/users',
      page: () => const UserScreen(),
      binding: BindingsBuilder(() {
        Get.put(UserController());
      }),
    ),
    GetPage(
      name: '/chat',
      page: () => const ChatScreen(),
      binding: BindingsBuilder(() {
        Get.put(ChatController());
      }),
    ),
    GetPage(
      name: '/loading',
      page: () => const LoadingScreen(),
      binding: BindingsBuilder(() {
        Get.put(AuthService());
        Get.put(SocketService());
      }),
    ),
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: '/licences',
      page: () => const LicencesScreen(),
    ),
  ];

  static String get initialRoute => '/loading';

  // Puedes agregar métodos de conveniencia para la navegación
  static void goToUsers() => Get.toNamed('/users');
  static void goToChat() => Get.toNamed('/chat');
  static void goToLogin() => Get.toNamed('/login');
  static void goToLicences() => Get.toNamed('/licences');
}

// import 'package:flutter/material.dart';
// import 'package:hand_held_shell/views/screens/screens.exports.files.dart';
// import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

// final Map<String, Widget Function(BuildContext)> appRoutes = {
//   'users': (_) => const UserScreen(),
//   'chat': (_) => const ChatScreen(),
//   'loading': (_) => const LoadingScreen(),
//   'login': (_) => const LoginScreen(),
//   'licences': (_) => const LicencesScreen(),
// };
