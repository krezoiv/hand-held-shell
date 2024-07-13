import 'package:get/get.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/chat.controller.dart';
import 'package:hand_held_shell/controllers/user.controller.dart';
import 'package:hand_held_shell/views/screens.exports.files.dart';

class UsersRoutes {
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
  ];
  static void goToChat() => Get.toNamed(RoutesPaths.chatHome);
  static void goToUsers() => Get.toNamed(RoutesPaths.userHome);
}
