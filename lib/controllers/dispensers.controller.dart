import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class DispenserController extends GetxController {
  final RxList<dynamic> dispenserReaders = <dynamic>[].obs;
  final RxBool isLoading = true.obs;
  final RxList<List<TextEditingController>> textControllers =
      <List<TextEditingController>>[].obs;

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
    } finally {
      isLoading.value = false;
    }
  }

  void updateTextField(int pageIndex, int cardIndex, String value) {
    textControllers[pageIndex][cardIndex].text = value;
  }

  String getTextFieldValue(int pageIndex, int cardIndex) {
    return textControllers[pageIndex][cardIndex].text;
  }

  Future<void> saveAllData() async {
    try {
      List<Map<String, dynamic>> dataToSave = [];
      for (int i = 0; i < dispenserReaders.length; i++) {
        dataToSave.add({
          'dispenserId': dispenserReaders[i]['_id'],
          'gallons': getTextFieldValue(i, 0),
          'mechanic': getTextFieldValue(i, 1),
          'money': getTextFieldValue(i, 2),
        });
      }
      await DispenserReaderService.saveDispenserReadings(dataToSave);
    } catch (e) {
      //
    }
  }
}
