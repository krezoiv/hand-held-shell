import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';

class DispenserControllerMethods {
  final DispenserController controller;

  DispenserControllerMethods(this.controller);

  void initializeDifferences() {
    controller.differences.assignAll(
      List.generate(controller.dispenserReaders.length,
          (_) => List.generate(3, (_) => '0'.obs)),
    );
  }

  void calculateDifference(int pageIndex, int cardIndex) {
    final previousValue = sanitizeTextField(controller
        .dispenserReaders[pageIndex][[
      'actualNoGallons',
      'actualNoMechanic',
      'actualNoMoney'
    ][cardIndex]]
        .toString());
    final currentValue = sanitizeTextField(
        controller.textControllers[pageIndex][cardIndex].text);

    if (currentValue.isNotEmpty && previousValue.isNotEmpty) {
      try {
        final difference =
            Decimal.parse(currentValue) - Decimal.parse(previousValue);
        controller.differences[pageIndex][cardIndex].value =
            formatNumber(difference.toStringAsFixed(difference.scale));
      } catch (e) {
        controller.differences[pageIndex][cardIndex].value = 'Error';
      }
    } else {
      controller.differences[pageIndex][cardIndex].value = '0';
    }
  }

  String sanitizeTextField(String text) {
    return text.replaceAll(',', '').replaceAll(' ', '').trim();
  }

  Decimal sanitizeAndParse(String value) {
    String sanitized = sanitizeTextField(value);
    if (sanitized.isEmpty) {
      throw FormatException("Empty field");
    }
    return Decimal.parse(sanitized);
  }

  String formatNumber(String number) {
    String cleanNumber = number.replaceAll(',', '');
    List<String> parts = cleanNumber.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    String formattedInteger = '';
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if ((integerPart.length - 1 - i) % 3 == 0 &&
          i != integerPart.length - 1) {
        formattedInteger = ',$formattedInteger';
      }
      formattedInteger = integerPart[i] + formattedInteger;
    }

    return formattedInteger + decimalPart;
  }

  void validateAndDisableFields(int pageIndex, int cardIndex) {
    if (!controller.isEditMode.value &&
        controller.dataSubmitted[pageIndex].value) return;

    final dispenserReader = controller.dispenserReaders[pageIndex];

    try {
      if (cardIndex == 0) {
        String previousNoGallons =
            sanitizeTextField(dispenserReader['actualNoGallons'].toString());
        String actualNoGallons =
            sanitizeTextField(controller.textControllers[pageIndex][0].text);

        if (actualNoGallons.isEmpty) {
          showValidationAlert(
              pageIndex, cardIndex, "El campo no puede estar vacío");
          return;
        }

        Decimal prevGallons = sanitizeAndParse(previousNoGallons);
        Decimal currGallons = sanitizeAndParse(actualNoGallons);

        if (currGallons < prevGallons) {
          showValidationAlert(
              pageIndex, cardIndex, "El campo no puede ser menor al anterior");
          return;
        }

        controller.buttonsEnabled[pageIndex][cardIndex].value = false;
        controller.textFieldsEnabled[pageIndex][0].value = false;
        focusNextField(pageIndex, 1);
      }

      if (cardIndex == 1) {
        String previousNoMechanic =
            sanitizeTextField(dispenserReader['actualNoMechanic'].toString());
        String actualNoMechanic =
            sanitizeTextField(controller.textControllers[pageIndex][1].text);

        if (actualNoMechanic.isEmpty) {
          showValidationAlert(
              pageIndex, cardIndex, "El campo no puede estar vacío");
          return;
        }

        Decimal prevMechanic = sanitizeAndParse(previousNoMechanic);
        Decimal currMechanic = sanitizeAndParse(actualNoMechanic);

        if (currMechanic < prevMechanic) {
          showValidationAlert(
              pageIndex, cardIndex, "El campo no puede ser menor al anterior");
          return;
        }

        controller.buttonsEnabled[pageIndex][cardIndex].value = false;
        controller.textFieldsEnabled[pageIndex][1].value = false;
        focusNextField(pageIndex, 2);
      }

      if (cardIndex == 2) {
        String previousNoMoney =
            sanitizeTextField(dispenserReader['actualNoMoney'].toString());
        String actualNoMoney =
            sanitizeTextField(controller.textControllers[pageIndex][2].text);

        if (actualNoMoney.isEmpty) {
          showValidationAlert(
              pageIndex, cardIndex, "El campo no puede estar vacío");
          return;
        }

        Decimal prevMoney = sanitizeAndParse(previousNoMoney);
        Decimal currMoney = sanitizeAndParse(actualNoMoney);

        if (currMoney < prevMoney) {
          showValidationAlert(
              pageIndex, cardIndex, "El campo no puede ser menor al anterior");
          return;
        }

        controller.buttonsEnabled[pageIndex][cardIndex].value = false;
        controller.textFieldsEnabled[pageIndex][2].value = false;
      }

      checkAllButtonsDisabled(pageIndex);
      controller.saveState();
    } catch (e) {
      showValidationAlert(pageIndex, cardIndex, "Error en la validación");
    }
  }

  void checkAllButtonsDisabled(int pageIndex) {
    bool allDisabled =
        controller.buttonsEnabled[pageIndex].every((button) => !button.value);
    controller.sendButtonEnabled.value = allDisabled;
  }

  void focusNextField(int pageIndex, int cardIndex) {
    if (cardIndex < 2) {
      controller.focusNodes[pageIndex][cardIndex + 1].requestFocus();
    }
  }

  void showValidationAlert(int pageIndex, int cardIndex, String message) {
    Get.snackbar(
      "Validación fallida",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
    controller.focusNodes[pageIndex][cardIndex].requestFocus();
  }

  void updateTextField(int pageIndex, int cardIndex, String value) {
    if (pageIndex < controller.textControllers.length &&
        cardIndex < controller.textControllers[pageIndex].length) {
      String formattedValue = formatNumber(
          value); // Formatear el número con separadores de millares
      controller.textControllers[pageIndex][cardIndex].text = formattedValue;
      controller.textControllers[pageIndex][cardIndex].selection =
          TextSelection.fromPosition(
        TextPosition(offset: formattedValue.length),
      );
      calculateDifference(pageIndex, cardIndex);
      controller.saveState();
    }
  }

  void setFocusToFirstField(int pageIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.focusNodes.isNotEmpty &&
          controller.focusNodes[pageIndex].isNotEmpty &&
          controller.focusNodes[pageIndex][0].canRequestFocus) {
        if (!controller.dataSubmitted[pageIndex].value) {
          for (int i = 0; i < 3; i++) {
            controller.textFieldsEnabled[pageIndex][i].value = true;
            controller.buttonsEnabled[pageIndex][i].value = true;
          }
        }
        controller.focusNodes[pageIndex][0].requestFocus();
      }
    });
  }

  void toggleEditMode(int pageIndex) {
    controller.isEditMode.value = !controller.isEditMode.value;
    if (controller.isEditMode.value) {
      enableEditMode(pageIndex);
    } else {
      disableEditMode(pageIndex);
    }
  }

  void enableEditMode(int pageIndex) {
    for (int i = 0; i < 3; i++) {
      if (!controller.buttonsEnabled[pageIndex][i].value) {
        controller.textFieldsEnabled[pageIndex][i].value = true;
        controller.buttonsEnabled[pageIndex][i].value = true;
      }
    }
  }

  void disableEditMode(int pageIndex) {
    for (int i = 0; i < 3; i++) {
      if (controller.textFieldsEnabled[pageIndex][i].value) {
        controller.textFieldsEnabled[pageIndex][i].value = false;
      }
    }
    controller.isEditMode.value = false;
  }

  String subtractPrecise(String a, String b) {
    var numA = sanitizeAndParse(a);
    var numB = sanitizeAndParse(b);
    return (numA - numB).toString();
  }

  void addNumberToActualField(int pageIndex, String number) {
    String currentText = controller.textControllers[pageIndex][1].text;
    if (number == '.' && currentText.contains('.')) return;
    controller.textControllers[pageIndex][1].text = currentText + number;
    controller.textControllers[pageIndex][1].selection =
        TextSelection.fromPosition(
      TextPosition(
          offset: controller.textControllers[pageIndex][1].text.length),
    );
  }

  void clearActualField(int pageIndex) {
    controller.textControllers[pageIndex][1].clear();
  }
}
