import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/config/menus/home.menu.dart';
import 'package:hand_held_shell/controllers/login.controller.dart';
// Importa UserController
import 'package:hand_held_shell/shared/shared.exports.files.dart';
import 'package:hand_held_shell/views/screens/home/presentation/widgets/custom.list.tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén la instancia del UserController
    final loginController = Get.find<LoginController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: ListView(
        children: [
          ...appMenuItems.map((menuItem) => ListTileHome(menuItem: menuItem)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CustomFilledButton(
              onPressed: () {
                loginController.logout(); // Llama al método logout
              },
              text: 'Salir',
            ),
          )
        ],
      ),
    );
  }
}


// leading: IconButton(
        //   icon: const Icon(
        //     Icons.logout,
        //     color: Colors.black87,
        //   ),
        //   onPressed: () {
        //     controller.logout();
        //   },
        // ),