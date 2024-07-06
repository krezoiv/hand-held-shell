import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;

  const UserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name ?? ''),
      subtitle: Text(user.email ?? ''),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[400],
        child: Text(
          user.name?.substring(0, 2) ?? '',
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
    );
  }
}
