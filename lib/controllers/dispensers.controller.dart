import 'package:flutter/cupertino.dart';
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

  final RxList<RxBool> showUpdateButtonList = <RxBool>[]
      .obs; // Lista para manejar la visibilidad del botón de actualización por página

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
        'differences': differences
            .map((list) => list.map((rx) => rx.value).toList())
            .toList(),
        'showUpdateButtonList':
            showUpdateButtonList.map((rx) => rx.value).toList(),
      };
      await prefs.setString('dispenserState', json.encode(state));
      hasSharedPreferencesData.value = true;
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

        differences.assignAll((state['differences'] as List)
            .map((list) =>
                (list as List).map((v) => RxString(v as String)).toList())
            .toList());

        showUpdateButtonList.assignAll((state['showUpdateButtonList'] as List)
            .map((v) => RxBool(v as bool))
            .toList());

        focusNodes.assignAll(
          List.generate(
            dispenserReaders.length,
            (index) => List.generate(3, (_) => FocusNode()),
          ),
        );

        isLoading.value = false;
        hasSharedPreferencesData.value = true;
        showCalculatorButtons.value = true;
      } else {
        await fetchDispenserReaders();
        hasSharedPreferencesData.value = false;
        showCalculatorButtons.value = false;
      }
    } catch (e) {
      print('Error loading state: $e');
      await fetchDispenserReaders();
      hasSharedPreferencesData.value = false;
      showCalculatorButtons.value = false;
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
            formatNumber(difference.toStringAsFixed(difference.scale));
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

      showUpdateButtonList.assignAll(
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
    saveState();
  }

  String _sanitizeTextField(String text) {
    return text.replaceAll(',', '').replaceAll(' ', '').trim();
  }

  Decimal sanitizeAndParse(String value) {
    String sanitized = _sanitizeTextField(value);
    if (sanitized.isEmpty) {
      throw FormatException("Empty field");
    }
    // Asegúrate de que el valor es un número válido
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(sanitized)) {
      throw FormatException("Invalid number format");
    }
    print('Sanitized value: $sanitized');
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
      saveState();
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

  Future<String?> sendDataToDatabase(int pageIndex) async {
    if (dataSubmitted[pageIndex].value || isLoading.value) return null;

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

      final newDispenserReaderId =
          await DispenserReaderService.addNewDispenserReader(
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

      if (newDispenserReaderId != null) {
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
          dataSubmitted[pageIndex].value = true;

          for (int i = 0; i < 3; i++) {
            textFieldsEnabled[pageIndex][i].value = false;
            buttonsEnabled[pageIndex][i].value = false;
          }

          sendButtonEnabled.value = false;

          showUpdateButtonList[pageIndex].value = true;

          // Actualizar el dispenserReaderId en el modelo local
          dispenserReaders[pageIndex]['dispenserReaderId'] =
              newDispenserReaderId;

          Get.snackbar(
              'Éxito', 'Los datos se han enviado y actualizado correctamente.');

          return newDispenserReaderId;
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
      saveState();
    }
    return null;
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

  Future<void> clearState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('dispenserState');
      resetState();
      hasSharedPreferencesData.value = false;
    } catch (e) {
      print('Error clearing state: $e');
    }
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

  // String formatNumberForParsing(String number) {
  //   // Elimina todos los espacios
  //   number = number.replaceAll(' ', '');

  //   // Si el número comienza con un punto, añade un 0 al principio
  //   if (number.startsWith('.')) {
  //     number = '0' + number;
  //   }

  //   // Reemplaza la coma por un punto
  //   number = number.replaceAll(',', '.');

  //   // Si hay más de un punto, elimina todos excepto el último
  //   var parts = number.split('.');
  //   if (parts.length > 2) {
  //     var lastPart = parts.removeLast();
  //     number = '${parts.join('')}.$lastPart';
  //   }

  //   return number;
  // }

  Future<void> updateDispenserReader(int pageIndex) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final dispenserReader = dispenserReaders[pageIndex];
      print('Dispenser Reader: $dispenserReader');

      final String dispenserReaderId = dispenserReader['dispenserReaderId'];
      final String generalDispenserReaderId =
          dispenserReader['generalDispenserReaderId'];

      print('Dispenser Reader ID: $dispenserReaderId');
      print('General Dispenser Reader ID: $generalDispenserReaderId');

      String newPreviousNoGallons =
          dispenserReader['actualNoGallons'].toString();
      String newActualNoGallons = textControllers[pageIndex][0].text.trim();
      String newPreviousNoMechanic =
          dispenserReader['actualNoMechanic'].toString();
      String newActualNoMechanic = textControllers[pageIndex][1].text.trim();
      String newPreviousNoMoney = dispenserReader['actualNoMoney'].toString();
      String newActualNoMoney = textControllers[pageIndex][2].text.trim();

      print('Before formatting:');
      print(
          'Previous Gallons: $newPreviousNoGallons, Actual Gallons: $newActualNoGallons');
      print(
          'Previous Mechanic: $newPreviousNoMechanic, Actual Mechanic: $newActualNoMechanic');
      print(
          'Previous Money: $newPreviousNoMoney, Actual Money: $newActualNoMoney');

      if (newActualNoGallons.isEmpty ||
          newActualNoMechanic.isEmpty ||
          newActualNoMoney.isEmpty) {
        throw Exception('One or more fields are empty');
      }

      // Formatea los números para el parsing
      newPreviousNoGallons = formatNumberForParsing(newPreviousNoGallons);
      newActualNoGallons = formatNumberForParsing(newActualNoGallons);
      newPreviousNoMechanic = formatNumberForParsing(newPreviousNoMechanic);
      newActualNoMechanic = formatNumberForParsing(newActualNoMechanic);
      newPreviousNoMoney = formatNumberForParsing(newPreviousNoMoney);
      newActualNoMoney = formatNumberForParsing(newActualNoMoney);

      print('After formatting:');
      print(
          'Previous Gallons: $newPreviousNoGallons, Actual Gallons: $newActualNoGallons');
      print(
          'Previous Mechanic: $newPreviousNoMechanic, Actual Mechanic: $newActualNoMechanic');
      print(
          'Previous Money: $newPreviousNoMoney, Actual Money: $newActualNoMoney');

      // Verifica que los números sean válidos antes de enviarlos
      if (double.tryParse(newActualNoGallons) == null ||
          double.tryParse(newActualNoMechanic) == null ||
          double.tryParse(newActualNoMoney) == null) {
        throw Exception('Invalid number format after parsing');
      }

      final bool success = await DispenserReaderService.updateDispenserReader(
        dispenserReaderId,
        newPreviousNoGallons,
        newActualNoGallons,
        newPreviousNoMechanic,
        newActualNoMechanic,
        newPreviousNoMoney,
        newActualNoMoney,
      );

      if (success) {
        // Actualizar los datos locales
        dispenserReaders[pageIndex]['previousNoGallons'] =
            double.parse(newPreviousNoGallons);
        dispenserReaders[pageIndex]['actualNoGallons'] =
            double.parse(newActualNoGallons);
        dispenserReaders[pageIndex]['previousNoMechanic'] =
            double.parse(newPreviousNoMechanic);
        dispenserReaders[pageIndex]['actualNoMechanic'] =
            double.parse(newActualNoMechanic);
        dispenserReaders[pageIndex]['previousNoMoney'] =
            double.parse(newPreviousNoMoney);
        dispenserReaders[pageIndex]['actualNoMoney'] =
            double.parse(newActualNoMoney);

        // Recalcular las diferencias
        calculateDifference(pageIndex, 0);
        calculateDifference(pageIndex, 1);
        calculateDifference(pageIndex, 2);

        showUpdateButtonList[pageIndex].value = false;
        sendButtonEnabled.value = false;
        dataSubmitted[pageIndex].value = true;

        Get.snackbar('Éxito', 'Los datos se han actualizado correctamente.');

        // Actualiza la vista
        update(['dispenserReader_$pageIndex']);
      } else {
        throw Exception('Failed to update dispenser reader');
      }
    } catch (e) {
      print('Error updating dispenser reader: $e');
      Get.snackbar(
          'Error', 'No se pudo actualizar los datos. Intente nuevamente.');
    } finally {
      isLoading.value = false;
      saveState();
    }
  }

  String formatNumberForParsing(String number) {
    // Elimina todos los espacios y comas
    number = number.replaceAll(' ', '').replaceAll(',', '');

    // Si el número comienza con un punto, añade un 0 al principio
    if (number.startsWith('.')) {
      number = '0' + number;
    }

    // Asegúrate de que solo haya un punto decimal
    var parts = number.split('.');
    if (parts.length > 2) {
      var integerPart = parts[0];
      var decimalPart = parts.sublist(1).join('');
      number = '$integerPart.$decimalPart';
    }

    // Si no hay punto decimal, añade .000 al final
    if (!number.contains('.')) {
      number += '.000';
    }

    // Asegúrate de que siempre haya tres decimales
    parts = number.split('.');
    if (parts.length == 2) {
      var decimalPart = parts[1].padRight(3, '0').substring(0, 3);
      number = '${parts[0]}.$decimalPart';
    }

    return number;
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
    differences.clear();
    showUpdateButtonList.clear();
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

/*
{
  previousNoGallons: 49930,
  actualNoGallons: 49941,
  totalNoGallons: 11,
  previousNoMechanic: 49930.732,
  actualNoMechanic: 49941.045,
  totalNoMechanic: 10.313,
  previousNoMoney: 1580972.11,
  actualNoMoney: 1581309.2,
  totalNoMoney: 337.09,
  assignmentHoseId: {
    _id: 633f69f1dad5b9b5ee4c42e1,
    position: 1,
    hoseId: {
      _id: 633f6036dad5b9b5ee4c4207,
      hoseColor: amarillo,
      fuelId: {
        _id: 633f4336345498b64890a931,
        fuelName: regular
      },
      statusId: 633f0e5bdcc030846c271119,
      __v: 0,
      code: 1
    },
    sideId: {
      _id: 633a2f683e373282cf01dee0,
      sideName: LadoA
    },
    assignmentId: {
      _id: 633f69d9dad5b9b5ee4c42db,
      dispenserId: {
        _id: 633f5c2d6fba6413361cbb6c,
        dispenserCode: bomba1
      },
      __v: 0
    },
    statusId: 633f0e5bdcc030846c271119,
    __v: 0
  },
  generalDispenserReaderId: 669c2f87fab4b4faa8261ec6,
  __v: 0,
  dispenserReaderId: 669c2fa4fab4b4faa8261ec9
}*/