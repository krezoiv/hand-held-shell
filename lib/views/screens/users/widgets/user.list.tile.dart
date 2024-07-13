import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/user.controller.dart';

import 'package:hand_held_shell/models/models/user.model.dart';

class UserListTile extends GetWidget<UserController> {
  final UserModel user;

  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.firstName),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[400],
        child: Text(
          user.firstName.substring(0, 2),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () => controller.navigateToChat(user),
    );
  }
}
