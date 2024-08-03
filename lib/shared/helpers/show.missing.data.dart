import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';

class ShowMissingDataDialog {
  static void show(BuildContext context,
      DispenserController dispenserController, int pageIndex) {
    Get.dialog(
      AlertDialog(
        title: const Text("Falta de datos"),
        content: const Text("Faltan datos por ingresar."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FocusScope.of(context)
                    .requestFocus(dispenserController.focusNodes[pageIndex][0]);
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
