// To parse this JSON data, do
//
//     final createUpdatePurchaseOrderResponse = createUpdatePurchaseOrderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

CreateUpdatePurchaseOrderResponse createUpdatePurchaseOrderResponseFromJson(
        String str) =>
    CreateUpdatePurchaseOrderResponse.fromJson(json.decode(str));

String createUpdatePurchaseOrderResponseToJson(
        CreateUpdatePurchaseOrderResponse data) =>
    json.encode(data.toJson());

class CreateUpdatePurchaseOrderResponse {
  bool ok;
  String message;
  PurchaseOrder purchaseOrder;

  CreateUpdatePurchaseOrderResponse({
    required this.ok,
    required this.message,
    required this.purchaseOrder,
  });

  factory CreateUpdatePurchaseOrderResponse.fromJson(
          Map<String, dynamic> json) =>
      CreateUpdatePurchaseOrderResponse(
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
