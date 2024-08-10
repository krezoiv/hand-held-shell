// To parse this JSON data, do
//
//     final newDepositsResponse = newDepositsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewDepositsResponse newDepositsResponseFromJson(String str) =>
    NewDepositsResponse.fromJson(json.decode(str));

String newDepositsResponseToJson(NewDepositsResponse data) =>
    json.encode(data.toJson());

class NewDepositsResponse {
  bool ok;
  String message;
  Deposit deposit;

  NewDepositsResponse({
    required this.ok,
    required this.message,
    required this.deposit,
  });

  factory NewDepositsResponse.fromJson(Map<String, dynamic> json) =>
      NewDepositsResponse(
        ok: json["ok"],
        message: json["message"],
        deposit: Deposit.fromJson(json["deposit"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "deposit": deposit.toJson(),
      };
}
