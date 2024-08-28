import 'package:flutter/material.dart';
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
        Get.snackbar(
          'Éxito',
          'Cupón creado exitosamente',
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
      if (e.toString().contains('Ya existe un cupón con este número')) {
        Get.snackbar(
          'Error',
          'Ya existe una cupón con este número',
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
          'Ocurrió un error al crear el cupón: ${e.toString()}',
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

  Future<void> fetchCouponsBySalesControl() async {
    try {
      isLoading.value = true;
      final response = await _couponsService.getCouponsSalesControl();

      if (response != null && response.ok && response.coupons.isNotEmpty) {
        couponsListResponse.value = response;
        // Get.snackbar('Éxito', 'Cupones obtenidas exitosamente');
      } else if (response != null && !response.ok) {
        Get.snackbar(
          'Error',
          'Error en la respuesta: ${response.coupons}',
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
          'No se encontraron los cupones',
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
        'Ocurrió un error al obtener los cupones: $e',
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

  Future<bool> deleteCoupon(String couponId) async {
    try {
      isLoading.value = true;
      final success = await _couponsService.deleteCoupon(couponId);

      if (success) {
        Get.snackbar(
          'Éxito',
          'Cupón eliminado exitosamente',
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
          'No se pudo eliminar el cupón',
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
        'Ocurrió un error al eliminar el cupón: $e',
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
