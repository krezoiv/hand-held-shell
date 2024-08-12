import 'package:get/get.dart';

import 'package:hand_held_shell/models/mappers/accounting/vouchers/new.voucher.response.dart';
import 'package:hand_held_shell/services/accounting/voucher/voucher.service.dart';

class VoucherController extends GetxController {
  final VoucherService _voucherService = VoucherService();

  final Rx<NewVoucherResponse?> newVoucherResponse =
      Rx<NewVoucherResponse?>(null);
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
}
