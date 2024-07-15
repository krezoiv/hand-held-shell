import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class CalculatorButton extends StatelessWidget {
  final Color bgColor;
  final bool big;
  final String text;
  final VoidCallback onPressed;

  const CalculatorButton({
    super.key,
    Color? bgColor,
    this.big = false,
    required this.text,
    required this.onPressed,
  }) : bgColor = bgColor ?? const Color(0xff333333);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: themeController.isDarkMode ? bgColor : Colors.blue[900],
      shape: const StadiumBorder(),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 5.0,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
        child: TextButton(
          style: buttonStyle,
          onPressed: onPressed,
          child: SizedBox(
            width: big ? 150 : 65,
            height: 75,
            child: Center(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
