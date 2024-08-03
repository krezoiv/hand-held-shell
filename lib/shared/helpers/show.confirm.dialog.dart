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
            onPressed: onCancel,
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            onPressed: onConfirm,
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
      onConfirm: onConfirm,
      onCancel: onCancel,
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
