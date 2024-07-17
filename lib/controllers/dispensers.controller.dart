import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class DispenserController extends GetxController {
  final RxList<dynamic> dispenserReaders = <dynamic>[].obs;
  final RxBool isLoading = true.obs;
  final RxList<List<TextEditingController>> textControllers =
      <List<TextEditingController>>[].obs;

  final showCalculatorButtons = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDispenserReaders();
  }

  Future<void> fetchDispenserReaders() async {
    try {
      isLoading.value = true;
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final readers = await DispenserReaderService.fetchDispenserReaders(token);
      dispenserReaders.assignAll(readers);

      textControllers.assignAll(
        List.generate(
          readers.length,
          (index) => List.generate(3, (_) => TextEditingController()),
        ),
      );
    } catch (e) {
      print('Error fetching dispenser readers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateTextField(int pageIndex, int cardIndex, String value) {
    textControllers[pageIndex][cardIndex].text = value;
  }

  String _sanitizeTextField(String text) {
    // Remove commas from the text field value
    return text.replaceAll(',', '');
  }

  Future<void> sendDataToDatabase(int pageIndex) async {
    try {
      final dispenserReader = dispenserReaders[pageIndex];
      final String assignmentHoseId =
          dispenserReader['assignmentHoseId']['_id'];

      // Gallons (CardIndex: 0)
      double previousNoGallons = double.tryParse(_sanitizeTextField(
              dispenserReader['actualNoGallons'].toString())) ??
          0.0;
      double actualNoGallons = double.tryParse(
              _sanitizeTextField(textControllers[pageIndex][0].text)) ??
          0.0;
      double totalNoGallons = actualNoGallons - previousNoGallons;

      // Mechanic (CardIndex: 1)
      double previousNoMechanic = double.tryParse(_sanitizeTextField(
              dispenserReader['actualNoMechanic'].toString())) ??
          0.0;
      double actualNoMechanic = double.tryParse(
              _sanitizeTextField(textControllers[pageIndex][1].text)) ??
          0.0;
      double totalNoMechanic = actualNoMechanic - previousNoMechanic;

      // Money (CardIndex: 2)
      double previousNoMoney = double.tryParse(_sanitizeTextField(
              dispenserReader['actualNoMoney'].toString())) ??
          0.0;
      double actualNoMoney = double.tryParse(
              _sanitizeTextField(textControllers[pageIndex][2].text)) ??
          0.0;
      double totalNoMoney = actualNoMoney - previousNoMoney;

      // Print the values to the console
      print('Data to be sent to the database:');
      print('previousNoGallons: $previousNoGallons');
      print('actualNoGallons: $actualNoGallons');
      print('totalNoGallons: $totalNoGallons');
      print('previousNoMechanic: $previousNoMechanic');
      print('actualNoMechanic: $actualNoMechanic');
      print('totalNoMechanic: $totalNoMechanic');
      print('previousNoMoney: $previousNoMoney');
      print('actualNoMoney: $actualNoMoney');
      print('totalNoMoney: $totalNoMoney');
      print('assignmentHoseId: $assignmentHoseId');

      // Uncomment the line below to send data to the database
      /*
      await DispenserReaderService.addNewDispenserReader(
        previousNoGallons.toInt(),
        actualNoGallons.toInt(),
        totalNoGallons.toInt(),
        previousNoMechanic.toInt(),
        actualNoMechanic.toInt(),
        totalNoMechanic.toInt(),
        previousNoMoney.toInt(),
        actualNoMoney.toInt(),
        totalNoMoney.toInt(),
        assignmentHoseId,
      );
      */
    } catch (e) {
      print('Error sending data to database: $e');
    }
  }

  // You might want to add a method to clear the text fields after sending data
  void clearTextFields(int pageIndex) {
    for (var controller in textControllers[pageIndex]) {
      controller.clear();
    }
  }

  // Don't forget to dispose of the controllers when they're no longer needed
  @override
  void onClose() {
    for (var controllerList in textControllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.onClose();
  }
}
