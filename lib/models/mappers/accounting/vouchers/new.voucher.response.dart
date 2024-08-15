// To parse this JSON data, do
//
//     final newVoucherResponse = newVoucherResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/models/acocounting/voucher.model.dart';

NewVoucherResponse newVoucherResponseFromJson(String str) =>
    NewVoucherResponse.fromJson(json.decode(str));

String newVoucherResponseToJson(NewVoucherResponse data) =>
    json.encode(data.toJson());

class NewVoucherResponse {
  bool ok;
  String message;
  Voucher voucher;

  NewVoucherResponse({
    required this.ok,
    required this.message,
    required this.voucher,
  });

  factory NewVoucherResponse.fromJson(Map<String, dynamic> json) =>
      NewVoucherResponse(
        ok: json["ok"],
        message: json["message"],
        voucher: Voucher.fromJson(json["voucher"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "voucher": voucher.toJson(),
      };
}
