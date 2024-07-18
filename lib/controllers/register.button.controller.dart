import 'package:get/get.dart';
import 'package:hand_held_shell/shared/helpers/text.helpers.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';

class RegisterButtonsController extends GetxController {
  late DispenserController dispenserController;
  RxInt currentCardIndex = 0.obs;

  void setDispenserController(DispenserController controller) {
    dispenserController = controller;
  }

  void setCurrentCardIndex(int index) {
    currentCardIndex.value = index;
  }

  void addNumber(String number, int pageIndex, int cardIndex) {
    String currentText =
        dispenserController.textControllers[pageIndex][cardIndex].text;

    if (number == 'C') {
      backspaceTextField(pageIndex, cardIndex);
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
    newText = _formatNumberWithCommas(newText);
    dispenserController.updateTextField(pageIndex, cardIndex, newText);
  }

  void backspaceTextField(int pageIndex, int cardIndex) {
    String currentText =
        dispenserController.textControllers[pageIndex][cardIndex].text;

    if (currentText.isNotEmpty) {
      if (currentText.endsWith(',')) {
        // Si el último carácter es una coma, borra dos caracteres
        currentText = currentText.substring(0, currentText.length - 2);
      } else {
        // Borra solo el último carácter
        currentText = currentText.substring(0, currentText.length - 1);
      }

      // Reformatea el número después de borrar
      currentText = _formatNumberWithCommas(currentText);

      dispenserController.updateTextField(pageIndex, cardIndex, currentText);
    }
  }

  void clearTextField(int pageIndex, int cardIndex) {
    dispenserController.updateTextField(pageIndex, cardIndex, '');
  }

  String _formatNumberWithCommas(String number) {
    // Elimina todas las comas existentes
    number = number.replaceAll(',', '');

    // Si el número está vacío, devuelve una cadena vacía
    if (number.isEmpty) return '';

    // Separa la parte entera y decimal (si existe)
    List<String> parts = number.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Formatea la parte entera con comas
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }

    // Combina la parte entera formateada con la parte decimal (si existe)
    return formattedInteger + decimalPart;
  }
}
