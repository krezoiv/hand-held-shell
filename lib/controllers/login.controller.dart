import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:hand_held_shell/services/services.exports.files.dart';

class LoginController extends GetxController {
  final AuthService authService = Get.find<AuthService>();
  final SocketService socketService = Get.find<SocketService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Por favor, complete todos los campos',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      final bool loginSuccess = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (loginSuccess) {
        socketService.connect();
        Get.offNamed('users');
      } else {
        Get.snackbar('Error', 'Credenciales incorrectas',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error inesperado',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
