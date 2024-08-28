import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/accounting/banks/list.bank.checks.sales.control.dart';
import 'package:hand_held_shell/services/accounting/banks/bank.check.service.dart';

class BankCheckController extends GetxController {
  final BankCheckService _bankCheckService = BankCheckService();

  final Rx<NewBankCheckResponse?> newBankCheckResponse =
      Rx<NewBankCheckResponse?>(null);

  final Rx<GetBankChecksListSaleControlResponse?> bankCheckListResponse =
      Rx<GetBankChecksListSaleControlResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createBankCheck({
    required int checkNumber,
    required num checkValue,
    required DateTime checkDate,
    required String bankId,
    required String clientId,
  }) async {
    try {
      isLoading.value = true;
      final response = await _bankCheckService.createBankCheck(
        checkNumber: checkNumber,
        checkValue: checkValue,
        checkDate: checkDate,
        bankId: bankId,
        clientId: clientId,
      );

      if (response != null && response.ok) {
        newBankCheckResponse.value = response;
        Get.snackbar(
          'Éxito',
          'Cheque creado exitosamente',
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
        FocusScope.of(Get.context!).unfocus();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e.toString().contains(
            'Ya existe un cheque con este número',
          )) {
        Get.snackbar(
          'Error',
          'Ya existe un cheque con este número',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.deepOrange[400],
          icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } else {
        Get.snackbar(
          'Error',
          'Ocurrió un error al crear el cheque: ${e.toString()}',
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
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBankCheckBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _bankCheckService.getbankChecksSalesControl();

      if (response != null && response.ok && response.bankCheck.isNotEmpty) {
        bankCheckListResponse.value = response;
        // Get.snackbar('Éxito', 'Cheques obtenidos exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar(
          'Error',
          'Error en la respuesta: ${response.bankCheck}',
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
      } else {
        Get.snackbar(
          'Error',
          'No se encontraron los cheques',
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
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al obtener los cheques: $e',
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
    }
  }

  Future<bool> deleteBankCheck(String bankCheckId) async {
    try {
      isLoading.value = true;
      final success = await _bankCheckService.deleteBankCheck(bankCheckId);

      if (success) {
        Get.snackbar(
          'Éxito',
          'Cheque eliminado exitosamente',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[600],
          icon: Icon(Icons.check_circle_outlined, color: Colors.green),
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          borderRadius: 20,
          duration: Duration(seconds: 3),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el cheque',
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
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al eliminar el cheque: $e',
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
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
