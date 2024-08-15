// To parse this JSON data, do
//
//     final newBankCheckResponse = newBankCheckResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/bank.check.model.dart';

NewBankCheckResponse newBankCheckResponseFromJson(String str) =>
    NewBankCheckResponse.fromJson(json.decode(str));

String newBankCheckResponseToJson(NewBankCheckResponse data) =>
    json.encode(data.toJson());

class NewBankCheckResponse {
  bool ok;
  String message;
  BankCheck bankCheck;

  NewBankCheckResponse({
    required this.ok,
    required this.message,
    required this.bankCheck,
  });

  factory NewBankCheckResponse.fromJson(Map<String, dynamic> json) =>
      NewBankCheckResponse(
        ok: json["ok"],
        message: json["message"],
        bankCheck: BankCheck.fromJson(json["bankCheck"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "bankCheck": bankCheck.toJson(),
      };
}
