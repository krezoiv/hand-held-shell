// To parse this JSON data, do
//
//     final deleteBillsResponse = deleteBillsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

DeleteBillsResponse deleteBillsResponseFromJson(String str) =>
    DeleteBillsResponse.fromJson(json.decode(str));

String deleteBillsResponseToJson(DeleteBillsResponse data) =>
    json.encode(data.toJson());

class DeleteBillsResponse {
  bool ok;
  Bill bill;
  String message;

  DeleteBillsResponse({
    required this.ok,
    required this.bill,
    required this.message,
  });

  factory DeleteBillsResponse.fromJson(Map<String, dynamic> json) =>
      DeleteBillsResponse(
        ok: json["ok"],
        bill: Bill.fromJson(json["bill"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "bill": bill.toJson(),
        "message": message,
      };
}
