import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/user.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class UserScreen extends GetView<UserController> {
  const UserScreen({super.key});

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
      body: GetBuilder<UserController>(
        builder: (controller) => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          onRefresh: controller.userLoad,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue,
          ),
          child: Obx(() {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.error.isNotEmpty) {
              return Center(child: Text(controller.error));
            } else {
              return _listViewUser(controller);
            }
          }),
        ),
      ),
    );
  }

  Widget _listViewUser(UserController controller) {
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
