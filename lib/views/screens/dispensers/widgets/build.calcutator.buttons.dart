import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/calculator.button.dart';

class BuildCalculatorButtons extends GetView<RegisterButtonsController> {
  final int pageIndex;

  const BuildCalculatorButtons({
    required this.pageIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCalculatorRow(['7', '8', '9']),
          SizedBox(height: 5),
          _buildCalculatorRow(['4', '5', '6']),
          SizedBox(height: 5),
          _buildCalculatorRow(['1', '2', '3']),
          _buildCalculatorRow(['0', '.', 'C']),
        ],
      ),
    );
  }

  Widget _buildCalculatorRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers
          .map((number) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CalculatorButton(
                    text: number,
                    onPressed: () {
                      controller.addNumber(
                          number, pageIndex, controller.currentCardIndex.value);
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }
}
