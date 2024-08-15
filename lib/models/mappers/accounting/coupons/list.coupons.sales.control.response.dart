// To parse this JSON data, do
//
//     final getCouponsListSaleControlResponse = getCouponsListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/coupons.model.dart';

GetCouponsListSaleControlResponse getCouponsListSaleControlResponseFromJson(
        String str) =>
    GetCouponsListSaleControlResponse.fromJson(json.decode(str));

String getCouponsListSaleControlResponseToJson(
        GetCouponsListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetCouponsListSaleControlResponse {
  bool ok;
  List<Coupon> coupons;

  GetCouponsListSaleControlResponse({
    required this.ok,
    required this.coupons,
  });

  factory GetCouponsListSaleControlResponse.fromJson(
          Map<String, dynamic> json) =>
      GetCouponsListSaleControlResponse(
        ok: json["ok"],
        coupons:
            List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "coupons": List<dynamic>.from(coupons.map((x) => x.toJson())),
      };
}
