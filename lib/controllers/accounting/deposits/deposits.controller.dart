import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/mappers/accounting/deposits/list.deposits.sales.control.response.dart';
import 'package:hand_held_shell/services/accounting/deposits/deposits.seervice.dart';

class DepositsController extends GetxController {
  final DepositsService _depostisService = DepositsService();
  final Rx<NewDepositsResponse?> newDepositsResponse =
      Rx<NewDepositsResponse?>(null);
  final Rx<GetDepositsListSaleControlResponse?> depositsitsListResponse =
      Rx<GetDepositsListSaleControlResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createDeposits({
    required int depositNumber,
    required num depositAmount,
    required DateTime depositDate,
    required String bankId,
  }) async {
    try {
      isLoading.value = true;
      final response = await _depostisService.createDeposits(
        depositNumber: depositNumber,
        depositAmount: depositAmount,
        depositDate: depositDate,
        bankId: bankId,
      );

      if (response != null && response.ok) {
        newDepositsResponse.value = response;
        Get.snackbar(
          'Éxito',
          'Depósito creado exitosamente',
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
            'Ya existe una depósito con este número',
          )) {
        Get.snackbar(
          'Error',
          'Ya existe una depósito con este número',
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
          'Ocurrió un error al crear el depósito: ${e.toString()}',
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

  Future<void> fetchDepositsBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _depostisService.getDepositsSalesControl();

      if (response != null && response.ok && response.deposits.isNotEmpty) {
        depositsitsListResponse.value = response;
        // Get.snackbar('Éxito', 'Depósitos obtenidos exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar(
          'Error',
          'Error en la respuesta: ${response.deposits}',
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
          'No se encontraron los depósitos',
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
        'Ocurrió un error al obtener los depósitos: $e',
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

  Future<bool> deleteDeposit(String creditId) async {
    try {
      isLoading.value = true;
      final success = await _depostisService.deleteDeposit(creditId);

      if (success) {
        Get.snackbar(
          'Éxito',
          'Depósito eliminado exitosamente',
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
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el depósito',
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
        'Ocurrió un error al eliminar el depósito: $e',
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
