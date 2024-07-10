import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future<void> checkLoginState() async {
    final authService = Get.find<AuthService>();
    final socketService = Get.find<SocketService>();

    await Future.delayed(Duration(
        seconds: 2)); // Añade un pequeño retraso para ver la pantalla de carga

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      Get.offNamed('/users');
    } else {
      Get.offNamed('/login');
    }
  }
}
