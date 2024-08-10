// To parse this JSON data, do
//
//     final newCouponsResponse = newCouponsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewCouponsResponse newCouponsResponseFromJson(String str) =>
    NewCouponsResponse.fromJson(json.decode(str));

String newCouponsResponseToJson(NewCouponsResponse data) =>
    json.encode(data.toJson());

class NewCouponsResponse {
  bool ok;
  String message;
  Coupon coupon;

  NewCouponsResponse({
    required this.ok,
    required this.message,
    required this.coupon,
  });

  factory NewCouponsResponse.fromJson(Map<String, dynamic> json) =>
      NewCouponsResponse(
        ok: json["ok"],
        message: json["message"],
        coupon: Coupon.fromJson(json["coupon"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "coupon": coupon.toJson(),
      };
}
