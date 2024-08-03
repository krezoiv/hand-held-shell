import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void showConfirmationDialog({
  String title = '',
  String message = '',
  String confirmText = 'Aceptar',
  String cancelText = 'Cancelar',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  if (GetPlatform.isAndroid) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText),
            onPressed: () {
              Get.back();
              if (onCancel != null) onCancel();
            },
          ),
          TextButton(
            child: Text(confirmText),
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
            },
          ),
        ],
      ),
    );
  } else if (GetPlatform.isIOS) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(cancelText),
            onPressed: () {
              Get.back();
              if (onCancel != null) onCancel();
            },
          ),
          CupertinoDialogAction(
            child: Text(confirmText),
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
            },
          ),
        ],
      ),
    );
  }
}
