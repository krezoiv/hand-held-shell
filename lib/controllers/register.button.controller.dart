import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispensers.controller.dart';

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
    dispenserController.methods.updateTextField(pageIndex, cardIndex, newText);
  }

  void backspaceTextField(int pageIndex, int cardIndex) {
    String currentText =
        dispenserController.textControllers[pageIndex][cardIndex].text;

    if (currentText.isNotEmpty) {
      if (currentText.endsWith(',')) {
        currentText = currentText.substring(0, currentText.length - 2);
      } else {
        currentText = currentText.substring(0, currentText.length - 1);
      }

      currentText = _formatNumberWithCommas(currentText);

      dispenserController.methods
          .updateTextField(pageIndex, cardIndex, currentText);
    }
  }

  void clearTextField(int pageIndex, int cardIndex) {
    dispenserController.methods.updateTextField(pageIndex, cardIndex, '');
  }

  static String _formatNumberWithCommas(String number) {
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
}
