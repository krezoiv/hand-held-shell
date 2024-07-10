import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void showAlert({
  String title = '',
  String message = '',
  String buttonText = 'Ok',
  VoidCallback? onConfirm,
}) {
  if (GetPlatform.isAndroid) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(buttonText),
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
            child: Text(buttonText),
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
