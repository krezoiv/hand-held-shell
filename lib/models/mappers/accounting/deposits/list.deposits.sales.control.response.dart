// To parse this JSON data, do
//
//     final getDepositsListSaleControlResponse = getDepositsListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/deposits.model.dart';

GetDepositsListSaleControlResponse getDepositsListSaleControlResponseFromJson(
        String str) =>
    GetDepositsListSaleControlResponse.fromJson(json.decode(str));

String getDepositsListSaleControlResponseToJson(
        GetDepositsListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetDepositsListSaleControlResponse {
  bool ok;
  List<Deposit> deposits;

  GetDepositsListSaleControlResponse({
    required this.ok,
    required this.deposits,
  });

  factory GetDepositsListSaleControlResponse.fromJson(
          Map<String, dynamic> json) =>
      GetDepositsListSaleControlResponse(
        ok: json["ok"],
        deposits: List<Deposit>.from(
            json["deposits"].map((x) => Deposit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "deposits": List<dynamic>.from(deposits.map((x) => x.toJson())),
      };
}
