// To parse this JSON data, do
//
//     final getVoucherListSaleControlResponse = getVoucherListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/voucher.model.dart';

GetVoucherListSaleControlResponse getVoucherListSaleControlResponseFromJson(
        String str) =>
    GetVoucherListSaleControlResponse.fromJson(json.decode(str));

String getVoucherListSaleControlResponseToJson(
        GetVoucherListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetVoucherListSaleControlResponse {
  bool ok;
  List<Voucher> vouchers;

  GetVoucherListSaleControlResponse({
    required this.ok,
    required this.vouchers,
  });

  factory GetVoucherListSaleControlResponse.fromJson(
          Map<String, dynamic> json) =>
      GetVoucherListSaleControlResponse(
        ok: json["ok"],
        vouchers: List<Voucher>.from(
            json["vouchers"].map((x) => Voucher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "vouchers": List<dynamic>.from(vouchers.map((x) => x.toJson())),
      };
}
