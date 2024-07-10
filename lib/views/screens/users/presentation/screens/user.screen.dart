import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/services/auth/users.service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/views/entities/models/user.model.dart';
import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.authService.usuario?.firstName ?? 'Usuario',
              style: const TextStyle(color: Colors.black87),
            )),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {
            controller.logout();
          },
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Obx(() => Icon(
                  Icons.check_circle,
                  color: controller.socketService.serverStatus ==
                          ServerStatus.Online
                      ? Colors.green[700]
                      : Colors.red,
                )),
          )
        ],
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        onRefresh: controller.userLoad,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: Obx(() => _listViewUser()),
      ),
    );
  }

  Widget _listViewUser() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) {
        final user = controller.users[i];
        return UserListTile(user: user);
      },
      separatorBuilder: (_, i) => const Divider(),
      itemCount: controller.users.length,
    );
  }
}

class UserController extends GetxController {
  final UserService userService = Get.find<UserService>();
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();
  final ChatService chatService = Get.find<ChatService>(); // Añade esta línea
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final RxList<UserModel> users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    userLoad();
    // Escuchar cambios en el estado de los usuarios
    socketService.on('user-status-changed', _handleUserStatusChange);
  }

  void navigateToChat(UserModel user) {
    chatService.toUser.value = user;
    Get.toNamed('/chat');
  }

  void userLoad() async {
    try {
      final loadedUsers = await userService.getUsers();
      users.assignAll(loadedUsers);
      refreshController.refreshCompleted();
    } catch (e) {
      print('Error loading users: $e');
      refreshController.refreshFailed();
    }
  }

  void _handleUserStatusChange(dynamic data) {
    final userId = data['userId'] as String;
    final isOnline = data['online'] as bool;
    final index = users.indexWhere((user) => user.userId == userId);
    if (index != -1) {
      users[index] = users[index].copyWith(online: isOnline);
    }
  }

  void logout() {
    socketService.disconnect();
    AuthService.deleteToken();
    Get.offAllNamed('login');
  }

  @override
  void onClose() {
    socketService.socket.off('user-status-changed');
    super.onClose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:hand_held_shell/services/auth/users.service.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:hand_held_shell/services/services.exports.files.dart';
// import 'package:hand_held_shell/views/entities/models/user.model.dart';
// import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

// class UserScreen extends StatefulWidget {
//   const UserScreen({super.key});

//   @override
//   State<UserScreen> createState() => _UserScreenState();
// }

// class _UserScreenState extends State<UserScreen> {
//   final userService = UserService();
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   //final List<UserModel> users = [];

//   List<UserModel> users = [];

//   @override
//   void initState() {
//     _userLoad();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final socketService = Provider.of<SocketService>(context);
//     final usuario = authService.usuario;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           usuario?.firstName ?? 'Usuario',
//           style: const TextStyle(color: Colors.black87),
//         ),
//         elevation: 1,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.exit_to_app,
//             color: Colors.black87,
//           ),
//           onPressed: () {
//             socketService.disconnect();

//             AuthService.deleteToken();
//             Navigator.pushReplacementNamed(context, 'login');
//           },
//         ),
//         actions: <Widget>[
//           Container(
//             margin: const EdgeInsets.only(right: 10),
//             child: Icon(
//               Icons.check_circle,
//               color: socketService.serverStatus == ServerStatus.Online
//                   ? Colors.green[700] // Online
//                   : Colors.red, // Offline
//             ),
//           )
//         ],
//       ),
//       body: SmartRefresher(
//         controller: _refreshController,
//         enablePullDown: true,
//         onRefresh: _userLoad,
//         header: WaterDropHeader(
//           complete: Icon(Icons.check, color: Colors.blue[400]),
//           waterDropColor: Colors.blue,
//         ),
//         child: _listViewUser(),
//       ),
//     );
//   }

//   ListView _listViewUser() {
//     return ListView.separated(
//       physics: const BouncingScrollPhysics(),
//       itemBuilder: (_, i) {
//         final user = users[i];
//         return UserListTile(user: user);
//       },
//       separatorBuilder: (_, i) => const Divider(),
//       itemCount: users.length,
//     );
//   }

//   _userLoad() async {
//     users = await userService.getUsers();

//     if (users.isEmpty) {
//     } else {}
//     setState(() {});
//     _refreshController.refreshCompleted();
//   }
// }
