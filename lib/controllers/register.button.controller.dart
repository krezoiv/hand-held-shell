import 'package:get/get.dart';
import 'package:hand_held_shell/config/helpers/text.helpers.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';

class RegisterButtonsController extends GetxController {
  late DispenserController
      dispenserController; // Cambia a late para inicializar después
  RxInt currentCardIndex = 0.obs;

  void setDispenserController(DispenserController controller) {
    dispenserController = controller;
  }

  void setCurrentCardIndex(int index) {
    currentCardIndex = index.obs;
  }

  void addNumber(String number, int pageIndex, int cardIndex) {
    String currentText =
        dispenserController.textControllers[pageIndex][cardIndex].text;

    if (number == 'C') {
      clearTextField(pageIndex, cardIndex);
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
    newText = TextHelpers.formatNumberForDisplay(newText);
    dispenserController.updateTextField(pageIndex, cardIndex, newText);
  }

  void clearTextField(int pageIndex, int cardIndex) {
    dispenserController.updateTextField(pageIndex, cardIndex, '');
  }
}
