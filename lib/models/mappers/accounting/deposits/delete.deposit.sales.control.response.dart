// To parse this JSON data, do
//
//     final deleteDepositResponse = deleteDepositResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/deposits.model.dart';

DeleteDepositResponse deleteDepositResponseFromJson(String str) =>
    DeleteDepositResponse.fromJson(json.decode(str));

String deleteDepositResponseToJson(DeleteDepositResponse data) =>
    json.encode(data.toJson());

class DeleteDepositResponse {
  bool ok;
  Deposit deposit;
  String message;

  DeleteDepositResponse({
    required this.ok,
    required this.deposit,
    required this.message,
  });

  factory DeleteDepositResponse.fromJson(Map<String, dynamic> json) =>
      DeleteDepositResponse(
        ok: json["ok"],
        deposit: Deposit.fromJson(json["deposit"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "deposit": deposit.toJson(),
        "message": message,
      };
}
