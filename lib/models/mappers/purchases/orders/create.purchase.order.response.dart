// To parse this JSON data, do
//
//     final createPurchaseOrderResponse = createPurchaseOrderResponseFromJson(jsonString);

import 'dart:convert';

CreatePurchaseOrderResponse createPurchaseOrderResponseFromJson(String str) =>
    CreatePurchaseOrderResponse.fromJson(json.decode(str));

String createPurchaseOrderResponseToJson(CreatePurchaseOrderResponse data) =>
    json.encode(data.toJson());

class CreatePurchaseOrderResponse {
  bool ok;
  String message;
  String purchaseOrderId;

  CreatePurchaseOrderResponse({
    required this.ok,
    required this.message,
    required this.purchaseOrderId,
  });

  factory CreatePurchaseOrderResponse.fromJson(Map<String, dynamic> json) =>
      CreatePurchaseOrderResponse(
        ok: json["ok"],
        message: json["message"],
        purchaseOrderId: json["purchaseOrderId"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "purchaseOrderId": purchaseOrderId,
      };
}
