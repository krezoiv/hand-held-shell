import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hand_held_shell/config/global/routes.path.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:hand_held_shell/shared/helpers/show.alert.dart';

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
      showAlert(
        title: 'Error',
        message: 'Por favor, complete todos los campos',
      );
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
        Get.offNamed(RoutesPaths.mainHome);
      } else {
        showAlert(
          title: 'Error',
          message: 'Credenciales incorrectas',
        );
      }
    } catch (e) {
      showAlert(
        title: 'Error',
        message: 'Ocurrió un error inesperado',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    socketService.disconnect();
    await AuthService.deleteToken();
    if (Get.isRegistered<DispenserController>()) {
      final dispenserController = Get.find<DispenserController>();
      await dispenserController.clearSharedPreferences();
      dispenserController
          .resetState(); // Implementa este método en DispenserController
    }
    Get.offAllNamed(RoutesPaths.loginHome);
  }
}
