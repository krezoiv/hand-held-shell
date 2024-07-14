import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class CalculatorButton extends StatelessWidget {
  final Color bgColor;
  final bool big;
  final String text;
  final Function onPressed;

  const CalculatorButton({
    super.key,
    bgColor,
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
      shape: StadiumBorder(),
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.black,
        elevation: 5.0,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(30),
        child: TextButton(
          style: buttonStyle,
          child: SizedBox(
            width: big ? 150 : 65,
            height: 75,
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          onPressed: () => onPressed(),
        ),
      ),
    );
  }
}
