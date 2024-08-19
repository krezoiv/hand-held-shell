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
  if (GetPlatform.isIOS) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Get.back(); // Cerrar el diálogo
              onCancel(); // Ejecutar la acción de cancelar
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
    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: confirmText,
      textCancel: cancelText,
      onConfirm: () {
        Get.back(); // Cerrar el diálogo
        onConfirm(); // Ejecutar la acción de confirmar
      },
      onCancel: () {
        Get.back(); // Cerrar el diálogo
        onCancel(); // Ejecutar la acción de cancelar
      },
      barrierDismissible: false,
      confirmTextColor: Colors.black,
      cancelTextColor: Colors.black,
      buttonColor: Colors.blue,
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
    );
  }
}
