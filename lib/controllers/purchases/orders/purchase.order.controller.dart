import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/purchases/orders/update.order.detail.dart';

import 'package:hand_held_shell/services/purchases/orders/purchases.orders.service.dart';

class PurchaseOrderController extends GetxController {
  final PurchaseOrderService _purchaseOrderService = PurchaseOrderService();
  final RxString purchaseOrderId = ''.obs;
  final RxBool isLoading = false.obs;
  Rx<UpdateOrderDetailResponse?> updateOrderDetailResponse =
      Rx<UpdateOrderDetailResponse?>(null);

  Future<void> createPurchaseOrder() async {
    try {
      isLoading.value = true;
      final response = await _purchaseOrderService.createPurchaseOrder();
      if (response.ok) {
        purchaseOrderId.value = response.purchaseOrderId;
        Get.snackbar('Success',
            'PurchaseOrder created successfully with ID: ${response.purchaseOrderId}');
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDetailPurchaseOrders(String purchaseOrderId) async {
    try {
      isLoading.value = true;
      final response = await _purchaseOrderService
          .createDetailPurchaseOrders(purchaseOrderId);
      if (response.ok) {
        Get.snackbar('Success', 'Detail Purchase Orders created successfully');
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Método para actualizar DetailPurchaseOrder
  Future<void> updateDetailPurchaseOrder({
    required String purchaseOrderId,
    required String fuelId,
    required num amount,
    required num price,
    required num idpTotal,
    required num total,
  }) async {
    try {
      isLoading.value = true;
      final response = await _purchaseOrderService.updateDetailPurchaseOrder(
        purchaseOrderId: purchaseOrderId,
        fuelId: fuelId,
        amount: amount,
        price: price,
        idpTotal: idpTotal,
        total: total,
      );

      if (response != null && response.ok) {
        updateOrderDetailResponse.value = response;
        Get.snackbar('Success', 'Detail Purchase Order updated successfully');
      } else {
        Get.snackbar('Error', response?.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update Detail Purchase Order: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
