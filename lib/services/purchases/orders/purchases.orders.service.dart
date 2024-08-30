import 'dart:convert';
import 'package:hand_held_shell/config/database/apis/purchases/purchase.order.detail.dart';
import 'package:hand_held_shell/config/database/apis/purchases/purchases.orders.api.dart';
import 'package:hand_held_shell/models/mappers/purchases/orders/create.purchase.order.details.response.dart';
import 'package:hand_held_shell/models/mappers/purchases/orders/create.purchase.order.response.dart';
import 'package:hand_held_shell/models/mappers/purchases/orders/update.order.detail.dart';

import 'package:hand_held_shell/services/services.exports.files.dart';
import 'package:http/http.dart' as http;

class PurchaseOrderService {
  Future<CreatePurchaseOrderResponse> createPurchaseOrder() async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse(PurchasesOrderApi.createPurchaseOrder()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
      );

      if (response.statusCode == 201) {
        return createPurchaseOrderResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error creating PurchaseOrder: $e');
    }
  }

  Future<CreateAllPurchaseOrderDetailsResponse> createDetailPurchaseOrders(
      String purchaseOrderId) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse(PurchasesOrderDetailApi.createAllPurchasesOrderDetail()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: jsonEncode({
          "purchaseOrderId": purchaseOrderId,
        }),
      );

      if (response.statusCode == 201) {
        return createPurchaseOrderDetailsResponseFromJson(response.body);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error creating DetailPurchaseOrders: $e');
    }
  }

  // Método para actualizar DetailPurchaseOrder
  Future<UpdateOrderDetailResponse?> updateDetailPurchaseOrder({
    required String purchaseOrderId,
    required String fuelId,
    required num amount,
    required num price,
    required num idpTotal,
    required num total,
  }) async {
    try {
      final String? token = await AuthService.getToken();
      if (token == null) throw Exception('Token is null');

      final response = await http.put(
        Uri.parse(PurchasesOrderDetailApi.updatePurchasesOrderDetail()),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token,
        },
        body: jsonEncode({
          "purchaseOrderId": purchaseOrderId,
          "fuelId": fuelId,
          "amount": amount,
          "price": price,
          "idpTotal": idpTotal,
          "total": total,
        }),
      );

      if (response.statusCode == 200) {
        return updateOrderDetailResponseFromJson(response.body);
      } else {
        throw Exception(
            'Failed to update DetailPurchaseOrder - StatusCode: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating DetailPurchaseOrder: $e');
    }
  }
}
