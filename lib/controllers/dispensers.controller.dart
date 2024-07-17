import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
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

      // Función auxiliar para sanitizar y convertir a Decimal
      Decimal sanitizeAndParse(String value) {
        String sanitized = value.replaceAll(',', '').trim();
        return Decimal.parse(sanitized);
      }

      // Función auxiliar para realizar una resta precisa
      String subtractPrecise(String a, String b) {
        var numA = sanitizeAndParse(a);
        var numB = sanitizeAndParse(b);
        return (numA - numB).toString();
      }

      // Gallons (CardIndex: 0)
      String previousNoGallons = dispenserReader['actualNoGallons'].toString();
      String actualNoGallons = textControllers[pageIndex][0].text;
      String totalNoGallons =
          subtractPrecise(actualNoGallons, previousNoGallons);

      // Mechanic (CardIndex: 1)
      String previousNoMechanic =
          dispenserReader['actualNoMechanic'].toString();
      String actualNoMechanic = textControllers[pageIndex][1].text;
      String totalNoMechanic =
          subtractPrecise(actualNoMechanic, previousNoMechanic);

      // Money (CardIndex: 2)
      String previousNoMoney = dispenserReader['actualNoMoney'].toString();
      String actualNoMoney = textControllers[pageIndex][2].text;
      String totalNoMoney = subtractPrecise(actualNoMoney, previousNoMoney);

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
      sanitizeAndParse(previousNoGallons).toInt(),
      sanitizeAndParse(actualNoGallons).toInt(),
      sanitizeAndParse(totalNoGallons).toInt(),
      sanitizeAndParse(previousNoMechanic).toInt(),
      sanitizeAndParse(actualNoMechanic).toInt(),
      sanitizeAndParse(totalNoMechanic).toInt(),
      sanitizeAndParse(previousNoMoney).toInt(),
      sanitizeAndParse(actualNoMoney).toInt(),
      sanitizeAndParse(totalNoMoney).toInt(),
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
