// To parse this JSON data, do
//
//     final updateReaderDispenserResponse = updateReaderDispenserResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

UpdateReaderDispenserResponse updateReaderDispenserResponseFromJson(
        String str) =>
    UpdateReaderDispenserResponse.fromJson(json.decode(str));

String updateReaderDispenserResponseToJson(
        UpdateReaderDispenserResponse data) =>
    json.encode(data.toJson());

class UpdateReaderDispenserResponse {
  bool ok;
  String msg;
  UpdatedDispenserReader updatedDispenserReader;
  UpdatedGeneralDispenserReader updatedGeneralDispenserReader;

  UpdateReaderDispenserResponse({
    required this.ok,
    required this.msg,
    required this.updatedDispenserReader,
    required this.updatedGeneralDispenserReader,
  });

  factory UpdateReaderDispenserResponse.fromJson(Map<String, dynamic> json) =>
      UpdateReaderDispenserResponse(
        ok: json["ok"],
        msg: json["msg"],
        updatedDispenserReader:
            UpdatedDispenserReader.fromJson(json["updatedDispenserReader"]),
        updatedGeneralDispenserReader: UpdatedGeneralDispenserReader.fromJson(
            json["updatedGeneralDispenserReader"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "updatedDispenserReader": updatedDispenserReader.toJson(),
        "updatedGeneralDispenserReader": updatedGeneralDispenserReader.toJson(),
      };
}
