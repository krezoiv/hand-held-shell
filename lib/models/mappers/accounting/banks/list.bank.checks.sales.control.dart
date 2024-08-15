// To parse this JSON data, do
//
//     final getBankChecksListSaleControlResponse = getBankChecksListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/bank.check.model.dart';

GetBankChecksListSaleControlResponse
    getBankChecksListSaleControlResponseFromJson(String str) =>
        GetBankChecksListSaleControlResponse.fromJson(json.decode(str));

String getBankChecksListSaleControlResponseToJson(
        GetBankChecksListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetBankChecksListSaleControlResponse {
  bool ok;
  List<BankCheck> bankCheck;

  GetBankChecksListSaleControlResponse({
    required this.ok,
    required this.bankCheck,
  });

  factory GetBankChecksListSaleControlResponse.fromJson(
          Map<String, dynamic> json) =>
      GetBankChecksListSaleControlResponse(
        ok: json["ok"],
        bankCheck: List<BankCheck>.from(
            json["bankCheck"].map((x) => BankCheck.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "bankCheck": List<dynamic>.from(bankCheck.map((x) => x.toJson())),
      };
}
