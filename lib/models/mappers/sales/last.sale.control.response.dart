// To parse this JSON data, do
//
//     final getLastSaleControlResponse = getLastSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

GetLastSaleControlResponse getLastSaleControlResponseFromJson(String str) =>
    GetLastSaleControlResponse.fromJson(json.decode(str));

String getLastSaleControlResponseToJson(GetLastSaleControlResponse data) =>
    json.encode(data.toJson());

class GetLastSaleControlResponse {
  bool ok;
  SalesControl salesControl;

  GetLastSaleControlResponse({
    required this.ok,
    required this.salesControl,
  });

  factory GetLastSaleControlResponse.fromJson(Map<String, dynamic> json) =>
      GetLastSaleControlResponse(
        ok: json["ok"],
        salesControl: SalesControl.fromJson(json["salesControl"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "salesControl": salesControl.toJson(),
      };
}
