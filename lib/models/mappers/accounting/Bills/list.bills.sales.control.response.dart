// To parse this JSON data, do
//
//     final getBillsListSaleControlResponse = getBillsListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

GetBillsListSaleControlResponse getBillsListSaleControlResponseFromJson(
        String str) =>
    GetBillsListSaleControlResponse.fromJson(json.decode(str));

String getBillsListSaleControlResponseToJson(
        GetBillsListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetBillsListSaleControlResponse {
  bool ok;
  List<Bill> bills;

  GetBillsListSaleControlResponse({
    required this.ok,
    required this.bills,
  });

  factory GetBillsListSaleControlResponse.fromJson(Map<String, dynamic> json) {
    print('Datos JSON recibidos: $json');
    return GetBillsListSaleControlResponse(
      ok: json["ok"],
      bills: List<Bill>.from(json["bills"].map((x) => Bill.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "bills": List<dynamic>.from(bills.map((x) => x.toJson())),
      };
}
