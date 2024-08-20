// To parse this JSON data, do
//
//     final deleteValeResponse = deleteValeResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

DeleteValeResponse deleteValeResponseFromJson(String str) =>
    DeleteValeResponse.fromJson(json.decode(str));

String deleteValeResponseToJson(DeleteValeResponse data) =>
    json.encode(data.toJson());

class DeleteValeResponse {
  bool ok;
  Vale vale;
  String message;

  DeleteValeResponse({
    required this.ok,
    required this.vale,
    required this.message,
  });

  factory DeleteValeResponse.fromJson(Map<String, dynamic> json) =>
      DeleteValeResponse(
        ok: json["ok"],
        vale: Vale.fromJson(json["vale"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "vale": vale.toJson(),
        "message": message,
      };
}
