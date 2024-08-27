import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/accounting/coupons/list.coupons.sales.control.response.dart';
import 'package:hand_held_shell/models/mappers/accounting/coupons/new.coupons.response.dart';
import 'package:hand_held_shell/services/accounting/coupons/coupons.service.dart';

class CouponsController extends GetxController {
  final CouponsService _couponsService = CouponsService();

  final Rx<NewCouponsResponse?> newVoucherResponse =
      Rx<NewCouponsResponse?>(null);
  final Rx<GetCouponsListSaleControlResponse?> couponsListResponse =
      Rx<GetCouponsListSaleControlResponse?>(null);

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
        Get.snackbar('Éxito', 'Cupón creado exitosamente');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e.toString().contains('Ya existe un cupón con este número')) {
        Get.snackbar('Error', 'Ya existe una cupón con este número');
      } else {
        Get.snackbar(
            'Error', 'Ocurrió un error al crear el cupón: ${e.toString()}');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCouponsBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _couponsService.getCouponsSalesControl();

      if (response != null && response.ok && response.coupons.isNotEmpty) {
        couponsListResponse.value = response;
        // Get.snackbar('Éxito', 'Cupones obtenidas exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar('Error', 'Error en la respuesta: ${response.coupons}');
      } else {
        Get.snackbar('Error', 'No se encontraron los cupones');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener los cupones: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteCoupon(String couponId) async {
    try {
      isLoading.value = true;
      final success = await _couponsService.deleteCoupon(couponId);

      if (success) {
        Get.snackbar('Éxito', 'Cupón eliminado exitosamente');
        return true;
      } else {
        Get.snackbar('Error', 'No se pudo eliminar el cupón');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el cupón: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
