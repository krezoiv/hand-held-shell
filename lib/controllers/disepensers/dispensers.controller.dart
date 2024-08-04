import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/controllers/disepensers/dispenser.controller.methods.dart';
import 'package:hand_held_shell/controllers/disepensers/modify.dispenser.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:hand_held_shell/services/dispensers/dispenser.reader.service.dart';
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
  final Rx<Map<String, dynamic>> dispenserReaderDetail =
      Rx<Map<String, dynamic>>({});

  late final DispenserControllerMethods methods;

  @override
  void onInit() {
    super.onInit();
    methods = DispenserControllerMethods(this);
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
    } catch (e) {
      // Manejar el error si es necesario
    }
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

      methods.initializeDifferences();

      if (readers.isNotEmpty) {
        methods.setFocusToFirstField(0);
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
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

      String previousNoGallons = methods
          .sanitizeTextField(dispenserReader['actualNoGallons'].toString());
      String actualNoGallons =
          methods.sanitizeTextField(textControllers[pageIndex][0].text);
      String totalNoGallons =
          methods.subtractPrecise(actualNoGallons, previousNoGallons);

      String previousNoMechanic = methods
          .sanitizeTextField(dispenserReader['actualNoMechanic'].toString());
      String actualNoMechanic =
          methods.sanitizeTextField(textControllers[pageIndex][1].text);
      String totalNoMechanic =
          methods.subtractPrecise(actualNoMechanic, previousNoMechanic);

      String previousNoMoney = methods
          .sanitizeTextField(dispenserReader['actualNoMoney'].toString());
      String actualNoMoney =
          methods.sanitizeTextField(textControllers[pageIndex][2].text);
      String totalNoMoney =
          methods.subtractPrecise(actualNoMoney, previousNoMoney);

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
              'Éxito', 'Los datos se han enviado y actualizado correctamente.');
        } else {
          throw Exception('Failed to update GeneralDispenserReader');
        }
      } else {
        throw Exception('Failed to add new dispenser reader');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo enviar los datos. Intente nuevamente.');
    } finally {
      isLoading.value = false;
      saveState();
    }
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

  void cleanupFocusNodes() {
    for (var i = 0; i < focusNodes.length; i++) {
      for (var j = 0; j < focusNodes[i].length; j++) {
        if (focusNodes[i][j].hasFocus) {
          focusNodes[i][j].unfocus();
        }
      }
    }
  }
}
