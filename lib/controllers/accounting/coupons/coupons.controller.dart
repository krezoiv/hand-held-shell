import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/coupons/new.coupons.response.dart';
import 'package:hand_held_shell/services/accounting/coupons/coupons.service.dart';

class CouponsController extends GetxController {
  final CouponsService _couponsService = CouponsService();

  final Rx<NewCouponsResponse?> newCouponsResponse =
      Rx<NewCouponsResponse?>(null);
  final RxBool isLoading = false.obs;

  Future<bool> createCoupons({
    required String cuponesNumber,
    required DateTime cuponesDate,
    required num cuponesAmount,
  }) async {
    try {
      isLoading.value = true;
      final response = await _couponsService.createCoupons(
        cuponesNumber: cuponesNumber,
        cuponesDate: cuponesDate,
        cuponesAmount: cuponesAmount,
      );

      if (response != null && response.ok) {
        newCouponsResponse.value = response;
        // Get.snackbar('Éxito', 'Cupón creado exitosamenteeee');
      }

      return true;
    } catch (e) {
      Get.snackbar(
          'Error', 'Ocurrió un error al crear el cupón: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
