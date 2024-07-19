import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:intl/intl.dart';

class DispenserController extends GetxController {
  final RxList<dynamic> dispenserReaders = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxList<List<TextEditingController>> textControllers =
      <List<TextEditingController>>[].obs;
  final RxList<List<FocusNode>> focusNodes = <List<FocusNode>>[].obs;
  final RxList<List<RxString>> differences = <List<RxString>>[].obs;

  final showCalculatorButtons = false.obs;
  final RxList<List<RxBool>> buttonsEnabled = <List<RxBool>>[].obs;
  final RxList<List<RxBool>> textFieldsEnabled = <List<RxBool>>[].obs;
  final RxBool sendButtonEnabled = false.obs;
  final RxBool hasSharedPreferencesData = false.obs;

  final RxList<RxBool> dataSubmitted = <RxBool>[].obs;

  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    loadState();
  }

  Future<void> saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final state = {
        'dispenserReaders':
            dispenserReaders.map((reader) => json.encode(reader)).toList(),
        'dataSubmitted': dataSubmitted.map((rx) => rx.value).toList(),
        'showCalculatorButtons': showCalculatorButtons.value,
        'sendButtonEnabled': sendButtonEnabled.value,
        'buttonsEnabled': buttonsEnabled
            .map((list) => list.map((rx) => rx.value).toList())
            .toList(),
        'textFieldsEnabled': textFieldsEnabled
            .map((list) => list.map((rx) => rx.value).toList())
            .toList(),
        'textControllers': textControllers
            .map((list) => list.map((controller) => controller.text).toList())
            .toList(),
      };
      await prefs.setString('dispenserState', json.encode(state));
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  Future<void> loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedState = prefs.getString('dispenserState');
      if (savedState != null) {
        final state = json.decode(savedState);

        dispenserReaders.assignAll(
            state['dispenserReaders'].map((r) => json.decode(r)).toList());

        dataSubmitted.assignAll((state['dataSubmitted'] as List)
            .map((v) => RxBool(v as bool))
            .toList());

        showCalculatorButtons.value = state['showCalculatorButtons'] as bool;
        sendButtonEnabled.value = state['sendButtonEnabled'] as bool;

        buttonsEnabled.assignAll((state['buttonsEnabled'] as List)
            .map(
                (list) => (list as List).map((v) => RxBool(v as bool)).toList())
            .toList());

        textFieldsEnabled.assignAll((state['textFieldsEnabled'] as List)
            .map(
                (list) => (list as List).map((v) => RxBool(v as bool)).toList())
            .toList());

        textControllers.assignAll((state['textControllers'] as List)
            .map((list) => (list as List)
                .map((text) => TextEditingController(text: text as String))
                .toList())
            .toList());

        focusNodes.assignAll(
          List.generate(
            dispenserReaders.length,
            (index) => List.generate(3, (_) => FocusNode()),
          ),
        );

        initializeDifferences();

        isLoading.value = false;
      } else {
        await fetchDispenserReaders();
      }
    } catch (e) {
      print('Error loading state: $e');
      await fetchDispenserReaders();
    }
  }

  void initializeDifferences() {
    differences.assignAll(
      List.generate(
          dispenserReaders.length, (_) => List.generate(3, (_) => '0'.obs)),
    );
  }

  void calculateDifference(int pageIndex, int cardIndex) {
    final previousValue = _sanitizeTextField(dispenserReaders[pageIndex][[
      'actualNoGallons',
      'actualNoMechanic',
      'actualNoMoney'
    ][cardIndex]]
        .toString());
    final currentValue =
        _sanitizeTextField(textControllers[pageIndex][cardIndex].text);

    if (currentValue.isNotEmpty && previousValue.isNotEmpty) {
      try {
        final difference =
            Decimal.parse(currentValue) - Decimal.parse(previousValue);
        differences[pageIndex][cardIndex].value =
            formatNumber(difference.toString());
      } catch (e) {
        print('Error calculating difference: $e');
        differences[pageIndex][cardIndex].value = 'Error';
      }
    } else {
      differences[pageIndex][cardIndex].value = '0';
    }
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

      focusNodes.assignAll(
        List.generate(
          readers.length,
          (index) => List.generate(3, (_) => FocusNode()),
        ),
      );

      buttonsEnabled.assignAll(
        List.generate(
          readers.length,
          (index) => List.generate(3, (_) => true.obs),
        ),
      );

      textFieldsEnabled.assignAll(
        List.generate(
          readers.length,
          (index) => List.generate(3, (_) => true.obs),
        ),
      );

      dataSubmitted.assignAll(
        List.generate(readers.length, (_) => false.obs),
      );

      initializeDifferences();

      if (readers.isNotEmpty) {
        setFocusToFirstField(0);
      }
    } catch (e) {
      print('Error fetching dispenser readers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setFocusToFirstField(int pageIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNodes.isNotEmpty &&
          focusNodes[pageIndex].isNotEmpty &&
          focusNodes[pageIndex][0].canRequestFocus) {
        if (!dataSubmitted[pageIndex].value) {
          for (int i = 0; i < 3; i++) {
            textFieldsEnabled[pageIndex][i].value = true;
            buttonsEnabled[pageIndex][i].value = true;
          }
        }
        focusNodes[pageIndex][0].requestFocus();
      }
    });
  }

  void updateTextField(int pageIndex, int cardIndex, String value) {
    textControllers[pageIndex][cardIndex].text = value;
    textControllers[pageIndex][cardIndex].selection =
        TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
    calculateDifference(pageIndex, cardIndex);
  }

  String _sanitizeTextField(String text) {
    return text.replaceAll(',', '').replaceAll(' ', '').trim();
  }

  Decimal sanitizeAndParse(String value) {
    String sanitized = _sanitizeTextField(value);
    if (sanitized.isEmpty) {
      throw FormatException("Empty field");
    }
    print('Sanitized value: $sanitized');
    return Decimal.parse(sanitized);
  }

  String formatNumber(String number) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(double.parse(number));
  }

  void validateAndDisableFields(int pageIndex, int cardIndex) {
    if (dataSubmitted[pageIndex].value) return;

    final dispenserReader = dispenserReaders[pageIndex];

    try {
      if (cardIndex == 0) {
        String previousNoGallons =
            _sanitizeTextField(dispenserReader['actualNoGallons'].toString());
        String actualNoGallons =
            _sanitizeTextField(textControllers[pageIndex][0].text);

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

        buttonsEnabled[pageIndex][cardIndex].value = false;
        textFieldsEnabled[pageIndex][0].value = false;
        focusNextField(pageIndex, 1);
      }

      if (cardIndex == 1) {
        String previousNoMechanic =
            _sanitizeTextField(dispenserReader['actualNoMechanic'].toString());
        String actualNoMechanic =
            _sanitizeTextField(textControllers[pageIndex][1].text);

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

        buttonsEnabled[pageIndex][cardIndex].value = false;
        textFieldsEnabled[pageIndex][1].value = false;
        focusNextField(pageIndex, 2);
      }

      if (cardIndex == 2) {
        String previousNoMoney =
            _sanitizeTextField(dispenserReader['actualNoMoney'].toString());
        String actualNoMoney =
            _sanitizeTextField(textControllers[pageIndex][2].text);

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

        buttonsEnabled[pageIndex][cardIndex].value = false;
        textFieldsEnabled[pageIndex][2].value = false;
      }

      checkAllButtonsDisabled(pageIndex);
    } catch (e) {
      print('Error in validation: $e');
      showValidationAlert(
          pageIndex, cardIndex, "El campo no puede estar vacío");
    }
  }

  void checkAllButtonsDisabled(int pageIndex) {
    bool allDisabled =
        buttonsEnabled[pageIndex].every((button) => !button.value);
    sendButtonEnabled.value = allDisabled;
  }

  Future<void> sendDataToDatabase(int pageIndex) async {
    if (dataSubmitted[pageIndex].value || isLoading.value) return;

    isLoading.value = true;

    try {
      final String? generalDispenserReaderId =
          await DispenserReaderService.getLastGeneralDispenserReaderId();

      if (generalDispenserReaderId == null) {
        throw Exception('No se pudo obtener el último GeneralDispenserReader');
      }

      final dispenserReader = dispenserReaders[pageIndex];
      final String assignmentHoseId =
          dispenserReader['assignmentHoseId']['_id'];

      Decimal sanitizeAndParse(String value) {
        String sanitized = value.replaceAll(',', '').trim();
        return Decimal.parse(sanitized);
      }

      String subtractPrecise(String a, String b) {
        var numA = sanitizeAndParse(a);
        var numB = sanitizeAndParse(b);
        return (numA - numB).toString(); // Mantiene precisión
      }

      String previousNoGallons =
          _sanitizeTextField(dispenserReader['actualNoGallons'].toString());
      String actualNoGallons =
          _sanitizeTextField(textControllers[pageIndex][0].text);
      String totalNoGallons =
          subtractPrecise(actualNoGallons, previousNoGallons);

      String previousNoMechanic =
          _sanitizeTextField(dispenserReader['actualNoMechanic'].toString());
      String actualNoMechanic =
          _sanitizeTextField(textControllers[pageIndex][1].text);
      String totalNoMechanic =
          subtractPrecise(actualNoMechanic, previousNoMechanic);

      String previousNoMoney =
          _sanitizeTextField(dispenserReader['actualNoMoney'].toString());
      String actualNoMoney =
          _sanitizeTextField(textControllers[pageIndex][2].text);
      String totalNoMoney = subtractPrecise(actualNoMoney, previousNoMoney);

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
      print('generalDispenserReaderId: $generalDispenserReaderId');

      final bool success = await DispenserReaderService.addNewDispenserReader(
        previousNoGallons,
        actualNoGallons,
        totalNoGallons,
        previousNoMechanic,
        actualNoMechanic,
        totalNoMechanic,
        previousNoMoney,
        actualNoMoney,
        totalNoMoney,
        assignmentHoseId,
        generalDispenserReaderId,
      );

      if (success) {
        final bool updateSuccess =
            await DispenserReaderService.updateGeneralDispenserReader(
          totalNoGallons,
          totalNoMechanic,
          totalNoMoney,
          assignmentHoseId,
          generalDispenserReaderId,
        );

        if (updateSuccess) {
          print('GeneralDispenserReader updated successfully');
          dataSubmitted[pageIndex] = true.obs;

          for (int i = 0; i < 3; i++) {
            textFieldsEnabled[pageIndex][i].value = false;
            buttonsEnabled[pageIndex][i].value = false;
          }

          sendButtonEnabled.value = false;

          if (pageIndex < dispenserReaders.length - 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.find<PageController>(tag: 'dispenser_page_controller')
                  .animateToPage(
                pageIndex + 1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          }

          Get.snackbar(
              'Éxito', 'Los datos se han enviado y actualizado correctamente.');
        } else {
          throw Exception('Failed to update GeneralDispenserReader');
        }
      } else {
        throw Exception('Failed to add new dispenser reader');
      }
    } catch (e) {
      print('Error sending data to database: $e');
      Get.snackbar('Error', 'No se pudo enviar los datos. Intente nuevamente.');
    } finally {
      isLoading.value = false;
    }
  }

  void focusNextField(int pageIndex, int cardIndex) {
    if (cardIndex < 2) {
      focusNodes[pageIndex][cardIndex + 1].requestFocus();
    }
  }

  void showValidationAlert(int pageIndex, int cardIndex, String message) {
    Get.snackbar(
      "Validación fallida",
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
    focusNodes[pageIndex][cardIndex].requestFocus();
  }

  Future<void> clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('dispenserState');
      hasSharedPreferencesData.value = false;
      print('SharedPreferences cleared successfully');
    } catch (e) {
      print('Error clearing SharedPreferences: $e');
    }
  }

  Future<void> checkSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedState = prefs.getString('dispenserState');
    hasSharedPreferencesData.value = savedState != null;
  }

  void resetState() {
    dispenserReaders.clear();
    isLoading.value = true;
    textControllers.clear();
    focusNodes.clear();
    showCalculatorButtons.value = false;
    buttonsEnabled.clear();
    textFieldsEnabled.clear();
    sendButtonEnabled.value = false;
    dataSubmitted.clear();
  }

  @override
  void onClose() {
    for (var controllerList in textControllers) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    for (var focusNodeList in focusNodes) {
      for (var focusNode in focusNodeList) {
        focusNode.dispose();
      }
    }
    super.onClose();
  }
}
