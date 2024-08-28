import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/vouchers/list.voucher.sales.control.response.dart';

import 'package:hand_held_shell/models/mappers/accounting/vouchers/new.voucher.response.dart';
import 'package:hand_held_shell/services/accounting/voucher/voucher.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class VoucherController extends GetxController {
  final VoucherService _voucherService = VoucherService();

  final Rx<NewVoucherResponse?> newVoucherResponse =
      Rx<NewVoucherResponse?>(null);
  final Rx<GetVoucherListSaleControlResponse?> voucherListResponse =
      Rx<GetVoucherListSaleControlResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createVoucher({
    required String authorizationCode,
    required String posId,
    required num voucherAmount,
    required DateTime voucherDate,
  }) async {
    try {
      isLoading.value = true;
      final response = await _voucherService.createVoucher(
        authorizationCode: authorizationCode,
        posId: posId,
        voucherAmount: voucherAmount,
        voucherDate: voucherDate,
      );

      if (response != null && response.ok) {
        newVoucherResponse.value = response;
        Get.snackbar(
          'Éxito',
          'Voucher creado exitosamente',
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
      if (e.toString().contains('Ya existe un voucher con este número')) {
        Get.snackbar(
          'Error',
          'Ya existe una voucher con este número',
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
          'Ocurrió un error al crear el voucher: ${e.toString()}',
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

  Future<void> fetchVoucherBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _voucherService.getVoucherSalesControl();

      if (response != null && response.ok && response.vouchers.isNotEmpty) {
        voucherListResponse.value = response;
        //Get.snackbar('Éxito', 'Vouchers obtenidas exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar(
          'Error',
          'Error en la respuesta: ${response.vouchers}',
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
          'No se encontraron los vouchers',
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
        'Ocurrió un error al obtener los vouchers: $e',
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

  Future<bool> deleteVoucher(String voucherId) async {
    try {
      isLoading.value = true;
      final success = await _voucherService.deleteVoucher(voucherId);

      if (success) {
        Get.snackbar(
          'Éxito',
          'Voucher eliminado exitosamente',
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
          'No se pudo eliminar el voucher',
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
        'Ocurrió un error al eliminar el voucher: $e',
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
