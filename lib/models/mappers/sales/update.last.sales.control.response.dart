// To parse this JSON data, do
//
//     final updateLastSalesControlResponse = updateLastSalesControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

UpdateLastSalesControlResponse updateLastSalesControlResponseFromJson(
        String str) =>
    UpdateLastSalesControlResponse.fromJson(json.decode(str));

String updateLastSalesControlResponseToJson(
        UpdateLastSalesControlResponse data) =>
    json.encode(data.toJson());

class UpdateLastSalesControlResponse {
  bool ok;
  String message;
  SalesControl salesControl;

  UpdateLastSalesControlResponse({
    required this.ok,
    required this.message,
    required this.salesControl,
  });

  factory UpdateLastSalesControlResponse.fromJson(Map<String, dynamic> json) =>
      UpdateLastSalesControlResponse(
        ok: json["ok"],
        message: json["message"],
        salesControl: SalesControl.fromJson(json["salesControl"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "salesControl": salesControl.toJson(),
      };
}
