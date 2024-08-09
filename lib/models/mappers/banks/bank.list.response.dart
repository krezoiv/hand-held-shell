// To parse this JSON data, do
//
//     final bankListResponse = bankListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

BankListResponse bankListResponseFromJson(String str) =>
    BankListResponse.fromJson(json.decode(str));

String bankListResponseToJson(BankListResponse data) =>
    json.encode(data.toJson());

class BankListResponse {
  bool ok;
  List<Bank> banks;
  String message;

  BankListResponse({
    required this.ok,
    required this.banks,
    required this.message,
  });

  factory BankListResponse.fromJson(Map<String, dynamic> json) =>
      BankListResponse(
        ok: json["ok"],
        banks: List<Bank>.from(json["banks"].map((x) => Bank.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "banks": List<dynamic>.from(banks.map((x) => x.toJson())),
        "message": message,
      };
}
