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

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// showAlert(BuildContext context, String title, String subTitle) {
//   if (Platform.isAndroid) {
//     return showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               title: Text(title),
//               content: Text(subTitle),
//               actions: <Widget>[
//                 MaterialButton(
//                     elevation: 5,
//                     textColor: Colors.blue,
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Ok'))
//               ],
//             ));
//   } else if (Platform.isIOS) {
//     return showCupertinoDialog(
//         context: context,
//         builder: (_) => CupertinoAlertDialog(
//                 title: Text(title),
//                 content: Text(subTitle),
//                 actions: <Widget>[
//                   CupertinoDialogAction(
//                     isDefaultAction: true,
//                     child: const Text('Ok'),
//                     onPressed: () => Navigator.pop(context),
//                   )
//                 ]));
//   }
// }
