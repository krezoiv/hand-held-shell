// update_calculator_buttons.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';

import 'package:hand_held_shell/views/screens/dispensers/widgets/calculator.update.button.dart';

class UpdateCalculatorButtons extends GetView<ModifyDispenserController> {
  final int cardIndex;
  const UpdateCalculatorButtons(this.cardIndex, {super.key});

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
            child: CalculatorUpdateButton(
              text: number,
              onPressed: () {
                controller.addNumber(number, controller.currentCardIndex.value);
              },
              bgColor: lastRow && number == 'C' ? Colors.orange : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
