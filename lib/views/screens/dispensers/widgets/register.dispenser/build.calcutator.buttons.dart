import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/register.button.controller.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';
import 'package:hand_held_shell/views/screens/dispensers/widgets/register.dispenser/calculator.button.dart';

class BuildCalculatorButtons extends GetView<RegisterButtonsController> {
  final int pageIndex;

  const BuildCalculatorButtons({
    required this.pageIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dispenserController = Get.find<DispenserController>();

    return Obx(() {
      if (dispenserController.showCalculatorButtonsPerPage.isEmpty ||
          pageIndex >=
              dispenserController.showCalculatorButtonsPerPage.length ||
          !dispenserController.showCalculatorButtonsPerPage[pageIndex].value) {
        return SizedBox.shrink();
      }

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
            _buildCalculatorRow(['0', '.', 'C'], lastRow: true),
          ],
        ),
      );
    });
  }

  Widget _buildCalculatorRow(List<String> numbers, {bool lastRow = false}) {
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
                    bgColor: lastRow && number == 'C' ? Colors.orange : null,
                  ),
                ),
              ))
          .toList(),
    );
  }
}
