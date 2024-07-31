import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/theme.controller.dart';

class UpdateCalculatorButtons extends GetView<DispenserController> {
  final int pageIndex;

  const UpdateCalculatorButtons({
    required this.pageIndex,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double spacing = constraints.maxWidth * 0.05;
        double buttonSize = (constraints.maxWidth - (spacing * 5)) / 4;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCalculatorRow(['7', '8', '9'], buttonSize, spacing),
            SizedBox(height: spacing),
            _buildCalculatorRow(['4', '5', '6'], buttonSize, spacing),
            SizedBox(height: spacing),
            _buildCalculatorRow(['1', '2', '3'], buttonSize, spacing),
            SizedBox(height: spacing),
            _buildCalculatorRow(['0', '.', 'C'], buttonSize, spacing,
                lastRow: true),
          ],
        );
      },
    );
  }

  Widget _buildCalculatorRow(
      List<String> numbers, double buttonSize, double spacing,
      {bool lastRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: UpdateCalculatorButton(
              text: number,
              onPressed: () {
                if (number == 'C') {
                  controller.clearActualField(pageIndex);
                } else {
                  controller.addNumberToActualField(pageIndex, number);
                }
              },
              bgColor: lastRow && number == 'C' ? Colors.orange : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class UpdateCalculatorButton extends StatelessWidget {
  final Color? bgColor;
  final String text;
  final VoidCallback onPressed;

  const UpdateCalculatorButton({
    Key? key,
    this.bgColor,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: bgColor ??
          (themeController.isDarkMode ? const Color(0xff333333) : Colors.green),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.zero,
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
