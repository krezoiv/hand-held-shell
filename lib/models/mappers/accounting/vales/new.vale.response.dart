// To parse this JSON data, do
//
//     final newValeResponse = newValeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

NewValeResponse newValeResponseFromJson(String str) =>
    NewValeResponse.fromJson(json.decode(str));

String newValeResponseToJson(NewValeResponse data) =>
    json.encode(data.toJson());

class NewValeResponse {
  bool ok;
  String message;
  Vale vale;

  NewValeResponse({
    required this.ok,
    required this.message,
    required this.vale,
  });

  factory NewValeResponse.fromJson(Map<String, dynamic> json) =>
      NewValeResponse(
        ok: json["ok"],
        message: json["message"],
        vale: Vale.fromJson(json["vale"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "vale": vale.toJson(),
      };
}
