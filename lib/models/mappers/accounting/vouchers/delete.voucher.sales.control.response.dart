// To parse this JSON data, do
//
//     final deleteVoucherResponse = deleteVoucherResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/voucher.model.dart';

DeleteVoucherResponse deleteVoucherResponseFromJson(String str) =>
    DeleteVoucherResponse.fromJson(json.decode(str));

String deleteVoucherResponseToJson(DeleteVoucherResponse data) =>
    json.encode(data.toJson());

class DeleteVoucherResponse {
  bool ok;
  Voucher voucher;
  String message;

  DeleteVoucherResponse({
    required this.ok,
    required this.voucher,
    required this.message,
  });

  factory DeleteVoucherResponse.fromJson(Map<String, dynamic> json) =>
      DeleteVoucherResponse(
        ok: json["ok"],
        voucher: Voucher.fromJson(json["voucher"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "voucher": voucher.toJson(),
        "message": message,
      };
}
