import 'package:flutter/material.dart';
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hand_held_shell/views/screens/users/users.exports.files.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final users = [
    UserModel(
        userId: '1',
        name: 'Kreiby',
        email: 'usuario1@gmail.com',
        online: false),
    UserModel(
        userId: '2', name: 'Zoe', email: 'usuario2@gmail.com', online: true),
    UserModel(
        userId: '3',
        name: 'Ivanna',
        email: 'usuario3@gmail.com',
        online: false),
    UserModel(
        userId: '4', name: 'Amanda', email: 'usuario4@gmail.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Screen',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _userLoad,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUser(),
      ),
    );
  }

  ListView _listViewUser() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) {
        final user = users[i];
        return UserListTile(user: user);
      },
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length,
    );
  }

  _userLoad() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _refreshController.refreshCompleted();
  }
}
