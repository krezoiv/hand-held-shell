// To parse this JSON data, do
//
//     final findPurchaseOrderResponse = findPurchaseOrderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/purchases/purchase.order.dart';

FindPurchaseOrderResponse findPurchaseOrderResponseFromJson(String str) =>
    FindPurchaseOrderResponse.fromJson(json.decode(str));

String findPurchaseOrderResponseToJson(FindPurchaseOrderResponse data) =>
    json.encode(data.toJson());

class FindPurchaseOrderResponse {
  bool ok;
  String message;
  PurchaseOrder purchaseOrder;

  FindPurchaseOrderResponse({
    required this.ok,
    required this.message,
    required this.purchaseOrder,
  });

  factory FindPurchaseOrderResponse.fromJson(Map<String, dynamic> json) =>
      FindPurchaseOrderResponse(
        ok: json["ok"],
        message: json["message"],
        purchaseOrder: PurchaseOrder.fromJson(json["purchaseOrder"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "purchaseOrder": purchaseOrder.toJson(),
      };
}
