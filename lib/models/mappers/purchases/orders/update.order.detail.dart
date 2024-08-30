// To parse this JSON data, do
//
//     final updateOrderDetailResponse = updateOrderDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/purchases/detail.purchase.order.dart';

UpdateOrderDetailResponse updateOrderDetailResponseFromJson(String str) =>
    UpdateOrderDetailResponse.fromJson(json.decode(str));

String updateOrderDetailResponseToJson(UpdateOrderDetailResponse data) =>
    json.encode(data.toJson());

class UpdateOrderDetailResponse {
  bool ok;
  String message;
  DetailPurchaseOrder detailPurchaseOrder;

  UpdateOrderDetailResponse({
    required this.ok,
    required this.message,
    required this.detailPurchaseOrder,
  });

  factory UpdateOrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      UpdateOrderDetailResponse(
        ok: json["ok"],
        message: json["message"],
        detailPurchaseOrder:
            DetailPurchaseOrder.fromJson(json["detailPurchaseOrder"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "detailPurchaseOrder": detailPurchaseOrder.toJson(),
      };
}
