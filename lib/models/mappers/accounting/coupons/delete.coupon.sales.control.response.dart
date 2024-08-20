// To parse this JSON data, do
//
//     final deleteCouponResponse = deleteCouponResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

DeleteCouponResponse deleteCouponResponseFromJson(String str) =>
    DeleteCouponResponse.fromJson(json.decode(str));

String deleteCouponResponseToJson(DeleteCouponResponse data) =>
    json.encode(data.toJson());

class DeleteCouponResponse {
  bool ok;
  Coupon coupon;
  String msg;

  DeleteCouponResponse({
    required this.ok,
    required this.coupon,
    required this.msg,
  });

  factory DeleteCouponResponse.fromJson(Map<String, dynamic> json) =>
      DeleteCouponResponse(
        ok: json["ok"],
        coupon: Coupon.fromJson(json["coupon"]),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "coupon": coupon.toJson(),
        "msg": msg,
      };
}
