// To parse this JSON data, do
//
//     final newSaleControlResponse = newSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

NewSaleControlResponse newSaleControlResponseFromJson(String str) =>
    NewSaleControlResponse.fromJson(json.decode(str));

String newSaleControlResponseToJson(NewSaleControlResponse data) =>
    json.encode(data.toJson());

class NewSaleControlResponse {
  bool ok;
  String msg;
  SalesControl salesControl;

  NewSaleControlResponse({
    required this.ok,
    required this.msg,
    required this.salesControl,
  });

  factory NewSaleControlResponse.fromJson(Map<String, dynamic> json) =>
      NewSaleControlResponse(
        ok: json["ok"],
        msg: json["msg"],
        salesControl: SalesControl.fromJson(json["salesControl"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "salesControl": salesControl.toJson(),
      };
}
