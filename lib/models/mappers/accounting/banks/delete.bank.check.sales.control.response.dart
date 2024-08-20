// To parse this JSON data, do
//
//     final deleteBankCheckResponse = deleteBankCheckResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/voucher.model.dart';

DeleteBankCheckResponse deleteBankCheckResponseFromJson(String str) =>
    DeleteBankCheckResponse.fromJson(json.decode(str));

String deleteBankCheckResponseToJson(DeleteBankCheckResponse data) =>
    json.encode(data.toJson());

class DeleteBankCheckResponse {
  bool ok;
  Voucher voucher;
  String message;

  DeleteBankCheckResponse({
    required this.ok,
    required this.voucher,
    required this.message,
  });

  factory DeleteBankCheckResponse.fromJson(Map<String, dynamic> json) =>
      DeleteBankCheckResponse(
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
