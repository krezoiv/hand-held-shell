import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/dispensers.controller.dart';

class RegisterButtonsController extends GetxController {
  late DispenserController
      dispenserController; // Cambia a late para inicializar después
  RxInt currentCardIndex = 0.obs;

  void setDispenserController(DispenserController controller) {
    dispenserController = controller;
  }

  //var currentCardIndex = 0.obs;

  void setCurrentCardIndex(int index) {
    currentCardIndex.value = index;
  }

  void addNumber(String number, int pageIndex, int cardIndex) {
    final textController =
        dispenserController.textControllers[pageIndex][cardIndex];
    final currentText = textController.text;

    if (number == 'C') {
      textController.clear();
    } else {
      textController.text = currentText + number;
    }
  }

  void clearTextField(int pageIndex, int cardIndex) {
    final textController =
        dispenserController.textControllers[pageIndex][cardIndex];
    textController.clear();
  }
}
