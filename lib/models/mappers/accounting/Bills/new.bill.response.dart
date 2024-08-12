// To parse this JSON data, do
//
//     final newBillResponse = newBillResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewValesResponse newBillResponseFromJson(String str) =>
    NewValesResponse.fromJson(json.decode(str));

String newBillResponseToJson(NewValesResponse data) =>
    json.encode(data.toJson());

class NewValesResponse {
  bool ok;
  String message;
  Bill bill;

  NewValesResponse({
    required this.ok,
    required this.message,
    required this.bill,
  });

  factory NewValesResponse.fromJson(Map<String, dynamic> json) =>
      NewValesResponse(
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
