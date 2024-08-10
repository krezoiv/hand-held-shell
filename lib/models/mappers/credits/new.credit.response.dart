// To parse this JSON data, do
//
//     final newCreditResponse = newCreditResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewCreditResponse newCreditResponseFromJson(String str) =>
    NewCreditResponse.fromJson(json.decode(str));

String newCreditResponseToJson(NewCreditResponse data) =>
    json.encode(data.toJson());

class NewCreditResponse {
  bool ok;
  String message;
  Credit credit;

  NewCreditResponse({
    required this.ok,
    required this.message,
    required this.credit,
  });

  factory NewCreditResponse.fromJson(Map<String, dynamic> json) =>
      NewCreditResponse(
        ok: json["ok"],
        message: json["message"],
        credit: Credit.fromJson(json["credit"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "credit": credit.toJson(),
      };
}
