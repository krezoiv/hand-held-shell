import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';

class UpdateCalculatorButtons extends GetView<ModifyDispenserController> {
  final int cardIndex;

  const UpdateCalculatorButtons({Key? key, required this.cardIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildRow(['7', '8', '9']),
          _buildRow(['4', '5', '6']),
          _buildRow(['1', '2', '3']),
          _buildRow(['0', '.', 'C']),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) => _buildButton(button)).toList(),
    );
  }

  Widget _buildButton(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(label),
          child: Text(
            label,
            style: TextStyle(fontSize: 24),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonPressed(String value) {
    controller.addNumber(value, cardIndex);
  }
}
