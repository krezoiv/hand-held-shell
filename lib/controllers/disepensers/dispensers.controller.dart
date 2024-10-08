import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hand_held_shell/services/fuel.statation/dispenser.reader.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class DispenserController extends GetxController {
  final RxList<dynamic> dispenserReaders = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxList<List<TextEditingController>> textControllers =
      <List<TextEditingController>>[].obs;
  final RxList<List<FocusNode>> focusNodes = <List<FocusNode>>[].obs;
  final RxList<List<RxString>> differences = <List<RxString>>[].obs;
  final RxBool showCalculatorButtons = false.obs;
  final RxList<List<RxBool>> buttonsEnabled = <List<RxBool>>[].obs;
  final RxList<List<RxBool>> textFieldsEnabled = <List<RxBool>>[].obs;
  final RxBool sendButtonEnabled = false.obs;
  final RxBool hasSharedPreferencesData = false.obs;
  final RxBool isEditMode = false.obs;
  final RxList<RxBool> dataSubmitted = <RxBool>[].obs;
  final FocusNode focusNode = FocusNode();
  final RxBool isAnyButtonDisabled = false.obs;
  final RxList<RxBool> showCalculatorButtonsPerPage = <RxBool>[].obs;
  final Rx<GeneralDispenserReader?> lastGeneralDispenserReader =
      Rx<GeneralDispenserReader?>(null);

  final RxBool isDataLoaded = false.obs;
  final RxBool isSummaryCardEnabled = true.obs;
  final Rx<Map<String, dynamic>> dispenserReaderDetail =
      Rx<Map<String, dynamic>>({});

  var totalSalesRegular = 0.0.obs;
  var totalSalesSuper = 0.0.obs;
  var totalSalesDiesel = 0.0.obs;

  @override
  void onInit() {
    super.onInit();

    ever(buttonsEnabled, _updateIsAnyButtonDisabled);
    loadState();
    showCalculatorButtonsPerPage.assignAll(
      List.generate(dispenserReaders.length, (_) => true.obs),
    );
  }

  void _updateIsAnyButtonDisabled(_) {
    isAnyButtonDisabled.value = buttonsEnabled
        .any((pageButtons) => pageButtons.any((button) => !button.value));
  }

  bool get isAnyButtonDisabledInCards {
    for (var pageButtons in buttonsEnabled) {
      for (var button in pageButtons) {
        if (!button.value) {
          return true;
        }
      }
    }
    return false;
  }

// En DispenserController
  bool canUpdateFields(int pageIndex) {
    return dataSubmitted[pageIndex].value &&
        !isLoading.value &&
        buttonsEnabled[pageIndex].every((button) => !button.value);
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
        'showCalculatorButtonsPerPage':
            showCalculatorButtonsPerPage.map((rx) => rx.value).toList(),
      };
      await prefs.setString('dispenserState', json.encode(state));
      hasSharedPreferencesData.value = true;
    } catch (e) {}
  }

  Future<void> loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedState = prefs.getString('dispenserState');
      if (savedState != null) {
        final state = json.decode(savedState);

        showCalculatorButtonsPerPage.assignAll(
            (state['showCalculatorButtonsPerPage'] as List)
                .map((v) => RxBool(v as bool))
                .toList());

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

        focusNodes.assignAll(
          List.generate(
            dispenserReaders.length,
            (index) => List.generate(3, (_) => FocusNode()),
          ),
        );

        ensureFocusNodesInitialized();
        isLoading.value = false;
        hasSharedPreferencesData.value = true;
        showCalculatorButtons.value = true;
      } else {
        await fetchDispenserReaders();
        hasSharedPreferencesData.value = false;
        showCalculatorButtons.value = false;
      }
    } catch (e) {
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

      showCalculatorButtonsPerPage.assignAll(
        List.generate(readers.length, (_) => true.obs),
      );

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
    } finally {
      isLoading.value = false;
    }
  }

  void setFocusToFirstField(int pageIndex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ensureFocusNodesInitialized();
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
    if (pageIndex < textControllers.length &&
        cardIndex < textControllers[pageIndex].length) {
      String formattedValue = formatNumber(
          value); // Formatear el número con separadores de millares
      textControllers[pageIndex][cardIndex].text = formattedValue;
      textControllers[pageIndex][cardIndex].selection =
          TextSelection.fromPosition(
        TextPosition(offset: formattedValue.length),
      );
      calculateDifference(pageIndex, cardIndex);
      saveState();
    }
  }

  String _sanitizeTextField(String text) {
    return text.replaceAll(',', '').replaceAll(' ', '').trim();
  }

  Decimal sanitizeAndParse(String value) {
    String sanitized = _sanitizeTextField(value);
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
    if (!isEditMode.value && dataSubmitted[pageIndex].value) return;

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
            pageIndex,
            cardIndex,
            "El campo no puede ser menor al anterior",
          );
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
      showValidationAlert(pageIndex, cardIndex, "Error en la validación");
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

      final result = await DispenserReaderService.addNewDispenserReader(
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

      if (result['success']) {
        final String? newDispenserReaderId = result['dispenserReaderId'];

        if (newDispenserReaderId != null) {
          // Asignar el nuevo dispenserReaderId al pageview actual
          dispenserReaders[pageIndex]['dispenserReaderId'] =
              newDispenserReaderId;
        }

        final bool updateSuccess =
            await DispenserReaderService.updateGeneralDispenserReader(
          totalNoGallons,
          totalNoMechanic,
          totalNoMoney,
          assignmentHoseId,
          generalDispenserReaderId,
        );

        if (updateSuccess) {
          dataSubmitted[pageIndex].value = true;

          for (int i = 0; i < 3; i++) {
            textFieldsEnabled[pageIndex][i].value = false;
            buttonsEnabled[pageIndex][i].value = false;
          }

          sendButtonEnabled.value = false;
          showCalculatorButtonsPerPage[pageIndex].value = false;
          update();

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
            'Éxito',
            'numeración guardada correctamente.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[600],
            icon: Icon(Icons.check_circle_outlined, color: Colors.white),
            colorText: Colors.white,
            margin: EdgeInsets.all(10),
            borderRadius: 20,
            duration: Duration(seconds: 3),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeOutBack,
          );
        } else {
          throw Exception(
            'Failed to update GeneralDispenserReader',
          );
        }
      } else {
        throw Exception('Failed to add new dispenser reader');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo enviar los datos. Intente nuevamente.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        icon: Icon(Icons.error_outline_outlined, color: Colors.white),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } finally {
      isLoading.value = false;
      saveState();
    }
  }

  void focusNextField(int pageIndex, int cardIndex) {
    if (cardIndex < 2) {
      focusNodes[pageIndex][cardIndex + 1].requestFocus();
    }
  }

  void showValidationAlert(int pageIndex, int cardIndex, String message) {
    Get.snackbar(
      "Alerta de Validación", // Título
      message, // Mensaje de error
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.deepOrange[400],
      colorText: Colors.white,
      icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );

    // Mantener el focus en el campo que causó el error
    focusNodes[pageIndex][cardIndex].requestFocus();
  }

  Future<void> clearState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('dispenserState');
      resetState();
      hasSharedPreferencesData.value = false;
    } catch (e) {}
  }

  Future<void> clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('dispenserState');
      hasSharedPreferencesData.value = false;
    } catch (e) {}
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
    differences.clear();
    showCalculatorButtonsPerPage.clear();
    ensureFocusNodesInitialized();
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

  void toggleEditMode(int pageIndex) {
    isEditMode.value = !isEditMode.value;
    if (isEditMode.value) {
      enableEditMode(pageIndex);
    } else {
      disableEditMode(pageIndex);
    }
  }

  void enableEditMode(int pageIndex) {
    for (int i = 0; i < 3; i++) {
      if (!buttonsEnabled[pageIndex][i].value) {
        textFieldsEnabled[pageIndex][i].value = true;
        buttonsEnabled[pageIndex][i].value = true;
      }
    }
  }

  void disableEditMode(int pageIndex) {
    for (int i = 0; i < 3; i++) {
      if (textFieldsEnabled[pageIndex][i].value) {
        textFieldsEnabled[pageIndex][i].value = false;
      }
    }
    isEditMode.value = false;
  }

  String subtractPrecise(String a, String b) {
    var numA = sanitizeAndParse(a);
    var numB = sanitizeAndParse(b);
    return (numA - numB).toString();
  }

  Future<void> fetchDispenserReaderDetail(String dispenserReaderId) async {
    try {
      isLoading.value = true;
      final detail = await DispenserReaderService.getDispenserReaderById(
          dispenserReaderId);
      dispenserReaderDetail.value = detail;
      Get.find<ModifyDispenserController>()
          .setValues(detail); // Cambiado de setActualValues a setValues
    } catch (e) {
      // Get.snackbar(
      //     'Error', 'No se pudo cargar los detalles del DispenserReader');
    } finally {
      isLoading.value = false;
    }
  }

  void addNumberToActualField(int pageIndex, String number) {
    String currentText = textControllers[pageIndex][1].text;
    if (number == '.' && currentText.contains('.')) return;
    textControllers[pageIndex][1].text = currentText + number;
    textControllers[pageIndex][1].selection = TextSelection.fromPosition(
      TextPosition(offset: textControllers[pageIndex][1].text.length),
    );
  }

  void clearActualField(int pageIndex) {
    textControllers[pageIndex][1].clear();
  }

  Future<void> fetchLastGeneralDispenserReaderData() async {
    try {
      isLoading.value = true;
      final response =
          await DispenserReaderService.getLastGeneralDispenserReader();
      if (response != null && response.ok) {
        lastGeneralDispenserReader.value = response.generalDispenserReader;
        isDataLoaded.value = true;
        isSummaryCardEnabled.value = false; // Deshabilita el card de resumen
      } else {
        throw Exception('Failed to fetch last GeneralDispenserReader data');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch last GeneralDispenserReader data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[600],
        icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: 20,
        duration: Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void ensureFocusNodesInitialized() {
    if (focusNodes.isEmpty || focusNodes.any((list) => list.isEmpty)) {
      focusNodes.assignAll(
        List.generate(
          dispenserReaders.length,
          (index) => List.generate(3, (_) => FocusNode()),
        ),
      );
    }
  }
}
