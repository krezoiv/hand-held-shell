import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterButtonsController extends GetxController {
  late TextEditingController textController;

  void setTextController(TextEditingController controller) {
    textController = controller;
  }

  void addNumber(String number) {
    if (number == 'C') {
      textController.clear();
      return;
    }

    String currentText = textController.text;

    if (number == '.' && currentText.contains('.')) {
      return;
    }

    if (currentText.isEmpty && number == '0') {
      return;
    }

    if (currentText.contains('.') && currentText.split('.')[1].length >= 3) {
      return;
    }

    textController.text += number;
    textController.text = formatNumberForDisplay(textController.text);
  }

  String formatNumberForDisplay(String number) {
    if (number.isEmpty) return '';

    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Eliminar cualquier coma existente para evitar duplicados
    integerPart = integerPart.replaceAll(',', '');

    // Revertir la parte entera para facilitar la inserción de comas
    String reversedIntegerPart = integerPart.split('').reversed.join();

    // Construir la parte entera con comas cada tres dígitos
    String formattedInteger = '';
    for (int i = 0; i < reversedIntegerPart.length; i++) {
      if (i != 0 && i % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += reversedIntegerPart[i];
    }

    // Revertir nuevamente para obtener el orden correcto
    formattedInteger = formattedInteger.split('').reversed.join();

    return formattedInteger + decimalPart;
  }
}
