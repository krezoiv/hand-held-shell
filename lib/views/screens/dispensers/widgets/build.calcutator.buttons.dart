import 'package:flutter/material.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/calculator.button.dart';

class BuildCalculatorButtons extends StatelessWidget {
  final RegisterButtonsController calculatorCtrl;
  final int pageIndex;
  final int currentCardIndex;

  const BuildCalculatorButtons({
    required this.calculatorCtrl,
    required this.pageIndex,
    required this.currentCardIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCalculatorRow(['7', '8', '9'], calculatorCtrl),
          SizedBox(height: 5),
          _buildCalculatorRow(['4', '5', '6'], calculatorCtrl),
          SizedBox(height: 5),
          _buildCalculatorRow(['1', '2', '3'], calculatorCtrl),
          _buildCalculatorRow(['0', '.', 'C'], calculatorCtrl),
        ],
      ),
    );
  }

  Widget _buildCalculatorRow(
      List<String> numbers, RegisterButtonsController calculatorCtrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers
          .map((number) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: CalculatorButton(
                    text: number,
                    onPressed: () {
                      calculatorCtrl.addNumber(
                          number, pageIndex, currentCardIndex);
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }
}
