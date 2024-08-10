// To parse this JSON data, do
//
//     final newBillResponse = newBillResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewBillResponse newBillResponseFromJson(String str) =>
    NewBillResponse.fromJson(json.decode(str));

String newBillResponseToJson(NewBillResponse data) =>
    json.encode(data.toJson());

class NewBillResponse {
  bool ok;
  String message;
  Bill bill;

  NewBillResponse({
    required this.ok,
    required this.message,
    required this.bill,
  });

  factory NewBillResponse.fromJson(Map<String, dynamic> json) =>
      NewBillResponse(
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
