import 'package:get/get.dart';
import 'package:hand_held_shell/models/mappers/purchases/orders/create.purchase.order.reponse.dart';
import 'package:hand_held_shell/models/mappers/purchases/orders/update.order.detail.dart';
import 'package:hand_held_shell/models/models/purchases/purchase.order.dart';

import 'package:hand_held_shell/services/purchases/orders/purchases.orders.service.dart';
import 'package:hand_held_shell/services/services.exports.files.dart';

class PurchaseOrderController extends GetxController {
  final PurchaseOrderService _purchaseOrderService = PurchaseOrderService();
  final RxString purchaseOrderId = ''.obs;
  final RxBool isLoading = false.obs;
  Rx<UpdateOrderDetailResponse?> updateOrderDetailResponse =
      Rx<UpdateOrderDetailResponse?>(null);
  Rx<CreateUpdatePurchaseOrderResponse?> createUpdatePurchaseOrderResponse =
      Rx<CreateUpdatePurchaseOrderResponse?>(null);
  final Rx<PurchaseOrder?> purchaseOrder = Rx<PurchaseOrder?>(null);

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

  Future<void> createOrUpdatePurchaseOrder({
    required String orderNumber,
    required DateTime orderDate,
    required DateTime deliveryDate,
    required num totalPurchaseOrder,
    required num totalIDPPurchaseOrder,
    required String storeId,
    required String vehicleId,
    required bool applied,
    required String turn,
    required num totalGallonRegular,
    required num totalGallonSuper,
    required num totalGallonDiesel,
  }) async {
    try {
      isLoading.value = true;

      // Obtener el userName desde el almacenamiento seguro
      final String? userName = await AuthService.getFirstName();

      if (userName == null) {
        throw Exception('Username is null');
      }

      final response = await _purchaseOrderService.createUpdatePurchaseOrder(
        orderNumber: orderNumber,
        orderDate: orderDate,
        deliveryDate: deliveryDate,
        totalPurchaseOrder: totalPurchaseOrder,
        totalIDPPurchaseOrder: totalIDPPurchaseOrder,
        storeId: storeId,
        vehicleId: vehicleId,
        applied: applied,
        turn: turn,
        totalGallonRegular: totalGallonRegular,
        totalGallonSuper: totalGallonSuper,
        totalGallonDiesel: totalGallonDiesel,
        userName:
            userName, // Usar el userName obtenido del almacenamiento seguro
      );

      if (response.ok) {
        createUpdatePurchaseOrderResponse.value = response;
        Get.snackbar(
            'Success', 'PurchaseOrder created or updated successfully');
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create or update PurchaseOrder: $e');
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

  Future<void> getPurchaseOrderByOrderNumber(String orderNumber) async {
    try {
      isLoading.value = true;
      final PurchaseOrder? order = await _purchaseOrderService
          .getPurchaseOrderByOrderNumber(orderNumber);
      if (order != null) {
        purchaseOrder.value = order;
        Get.snackbar('Success', 'PurchaseOrder found successfully');
      } else {
        Get.snackbar('Error',
            'No se encontró ninguna orden de compra con el número de orden: $orderNumber');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get PurchaseOrder: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
