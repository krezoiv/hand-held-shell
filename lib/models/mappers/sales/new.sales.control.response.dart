// To parse this JSON data, do
//
//     final newSalesControlResponse = newSalesControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

NewSalesControlResponse newSalesControlResponseFromJson(String str) =>
    NewSalesControlResponse.fromJson(json.decode(str));

String newSalesControlResponseToJson(NewSalesControlResponse data) =>
    json.encode(data.toJson());

class NewSalesControlResponse {
  bool ok;
  String message;
  SalesControl salesControl; // Cambiar el tipo aquí a SalesControl

  NewSalesControlResponse({
    required this.ok,
    required this.message,
    required this.salesControl,
  });

  factory NewSalesControlResponse.fromJson(Map<String, dynamic> json) =>
      NewSalesControlResponse(
        ok: json["ok"],
        salesControl: SalesControl.fromJson(json["salesControl"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "salesControl": salesControl.toJson(),
      };
}
