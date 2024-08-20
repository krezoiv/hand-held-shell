// To parse this JSON data, do
//
//     final deleteCreditResponse = deleteCreditResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/credit.model.dart';

DeleteCreditResponse deleteCreditResponseFromJson(String str) =>
    DeleteCreditResponse.fromJson(json.decode(str));

String deleteCreditResponseToJson(DeleteCreditResponse data) =>
    json.encode(data.toJson());

class DeleteCreditResponse {
  bool ok;
  Credit credit;
  String message;

  DeleteCreditResponse({
    required this.ok,
    required this.credit,
    required this.message,
  });

  factory DeleteCreditResponse.fromJson(Map<String, dynamic> json) =>
      DeleteCreditResponse(
        ok: json["ok"],
        credit: Credit.fromJson(json["credit"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "credit": credit.toJson(),
        "message": message,
      };
}
