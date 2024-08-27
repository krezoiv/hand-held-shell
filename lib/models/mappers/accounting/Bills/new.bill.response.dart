// To parse this JSON data, do
//
//     final newBillResponse = newBillResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewBillsResponse newBillResponseFromJson(String str) =>
    NewBillsResponse.fromJson(json.decode(str));

String newBillResponseToJson(NewBillsResponse data) =>
    json.encode(data.toJson());

class NewBillsResponse {
  bool ok;
  String message;
  Bill bill;

  NewBillsResponse({
    required this.ok,
    required this.message,
    required this.bill,
  });

  factory NewBillsResponse.fromJson(Map<String, dynamic> json) =>
      NewBillsResponse(
        ok: json["ok"],
        message: json["message"],
        bill: Bill.fromJson(json["bill"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "bill": bill.toJson(),
      };
}
