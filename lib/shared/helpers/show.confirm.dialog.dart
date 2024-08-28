import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showConfirmationDialog({
  required String title,
  required String message,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  FocusScope.of(Get.context!).unfocus();
  if (GetPlatform.isIOS) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back(); // Cerrar el diálogo
              // No llamamos a onCancel() aquí
            },
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Get.back(); // Cerrar el diálogo
              onConfirm(); // Ejecutar la acción de confirmar
            },
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  } else {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Cerrar el diálogo
              // No llamamos a onCancel() aquí
            },
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Cerrar el diálogo
              onConfirm(); // Ejecutar la acción de confirmar
            },
            child: Text(confirmText),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
