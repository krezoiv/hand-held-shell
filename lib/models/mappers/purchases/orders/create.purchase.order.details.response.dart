// To parse this JSON data, do
//
//     final createPurchaseOrderDetailsResponse = createPurchaseOrderDetailsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/purchases/detail.purchase.order.dart';

CreateAllPurchaseOrderDetailsResponse
    createPurchaseOrderDetailsResponseFromJson(String str) =>
        CreateAllPurchaseOrderDetailsResponse.fromJson(json.decode(str));

String createAllPurchaseOrderDetailsResponseToJson(
        CreateAllPurchaseOrderDetailsResponse data) =>
    json.encode(data.toJson());

class CreateAllPurchaseOrderDetailsResponse {
  bool ok;
  String message;
  List<DetailPurchaseOrder> detailPurchaseOrders;
  String purchaseOrderId;

  CreateAllPurchaseOrderDetailsResponse({
    required this.ok,
    required this.message,
    required this.detailPurchaseOrders,
    required this.purchaseOrderId,
  });

  factory CreateAllPurchaseOrderDetailsResponse.fromJson(
          Map<String, dynamic> json) =>
      CreateAllPurchaseOrderDetailsResponse(
        ok: json["ok"],
        message: json["message"],
        detailPurchaseOrders: List<DetailPurchaseOrder>.from(
            json["detailPurchaseOrders"]
                .map((x) => DetailPurchaseOrder.fromJson(x))),
        purchaseOrderId: json["purchaseOrderId"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "detailPurchaseOrders":
            List<dynamic>.from(detailPurchaseOrders.map((x) => x.toJson())),
        "purchaseOrderId": purchaseOrderId,
      };
}
