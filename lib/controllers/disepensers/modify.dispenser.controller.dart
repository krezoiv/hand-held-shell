// modify_dispenser_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ModifyDispenserController extends GetxController {
  final List<TextEditingController> previousControllers =
      List.generate(3, (_) => TextEditingController());
  List<TextEditingController> actualControllers =
      List.generate(3, (_) => TextEditingController());
  RxInt currentCardIndex = 0.obs;
  final List<RxString> totalValues = List.generate(3, (_) => RxString(''));

  @override
  void onInit() {
    super.onInit();
    actualControllers = List.generate(3, (_) => TextEditingController());
  }

  void setCurrentCardIndex(int index) {
    currentCardIndex.value = index;
  }

  void setValues(Map<String, dynamic> detail) {
    previousControllers[0].text = detail['previousNoGallons']?.toString() ?? '';
    previousControllers[1].text =
        detail['previousNoMechanic']?.toString() ?? '';
    previousControllers[2].text = detail['previousNoMoney']?.toString() ?? '';

    actualControllers[0].text = detail['actualNoGallons']?.toString() ?? '';
    actualControllers[1].text = detail['actualNoMechanic']?.toString() ?? '';
    actualControllers[2].text = detail['actualNoMoney']?.toString() ?? '';

    totalValues[0].value = detail['totalNoGallons']?.toString() ?? 'N/A';
    totalValues[1].value = detail['totalNoMechanic']?.toString() ?? 'N/A';
    totalValues[2].value = detail['totalNoMoney']?.toString() ?? 'N/A';

    for (int i = 0; i < 3; i++) {
      actualControllers[i].addListener(() => calculateTotal(i));
    }

    update();
  }

  void calculateTotal(int index) {
    double previous =
        double.tryParse(previousControllers[index].text.replaceAll(',', '')) ??
            0;
    double actual =
        double.tryParse(actualControllers[index].text.replaceAll(',', '')) ?? 0;
    double total = actual - previous;
    totalValues[index].value = total.toStringAsFixed(2);
    update();
  }

  void addNumber(String number, int cardIndex) {
    String currentText = actualControllers[cardIndex].text;

    if (number == 'C') {
      backspaceTextField(cardIndex);
      return;
    }

    if (number == '.' && currentText.contains('.')) {
      return;
    }

    if (currentText.isEmpty && number == '0') {
      return;
    }

    if (currentText.contains('.') && currentText.split('.')[1].length >= 3) {
      return;
    }

    String newText = currentText + number;
    newText = formatNumberWithCommas(newText);
    updateTextField(cardIndex, newText);
  }

  void backspaceTextField(int cardIndex) {
    String currentText = actualControllers[cardIndex].text;

    if (currentText.isNotEmpty) {
      if (currentText.endsWith(',')) {
        currentText = currentText.substring(0, currentText.length - 2);
      } else {
        currentText = currentText.substring(0, currentText.length - 1);
      }

      currentText = formatNumberWithCommas(currentText);

      updateTextField(cardIndex, currentText);
    }
  }

  void updateTextField(int cardIndex, String value) {
    actualControllers[cardIndex].text = value;
    actualControllers[cardIndex].selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
  }

  String formatNumberWithCommas(String number) {
    number = number.replaceAll(',', '');

    if (number.isEmpty) return '';

    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }

    return formattedInteger + decimalPart;
  }

  TextStyle getTotalTextStyle(int cardIndex) {
    final totalValue = totalValues[cardIndex].value;
    final double? numericValue = double.tryParse(totalValue);
    Color textColor;

    if (numericValue == null) {
      textColor = Colors.black;
    } else if (numericValue < 0) {
      textColor = Colors.red;
    } else if (numericValue == 0) {
      textColor = Colors.blue;
    } else {
      textColor = Colors.green;
    }

    return TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  @override
  void onClose() {
    for (var controller in actualControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
