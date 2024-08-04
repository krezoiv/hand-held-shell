import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hand_held_shell/controllers/theme.controller.dart';

class CalculatorButton extends StatelessWidget {
  final Color? bgColor;
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    this.bgColor,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: bgColor ??
          (themeController.isDarkMode
              ? const Color(0xff333333)
              : Colors.blue[300]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.zero,
    );

    return SizedBox.expand(
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
