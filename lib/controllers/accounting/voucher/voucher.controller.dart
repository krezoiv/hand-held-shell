import 'package:get/get.dart';

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
        // Get.snackbar('Éxito', 'Cupón creado exitosamenteeee');
      }

      return true;
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al crear el voucher: ${e.toString()}');
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
        Get.snackbar('Éxito', 'Vouchers obtenidas exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.vouchers}');
      } else {
        Get.snackbar('Error', 'No se encontraron los vouchers');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener los vouchers: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
