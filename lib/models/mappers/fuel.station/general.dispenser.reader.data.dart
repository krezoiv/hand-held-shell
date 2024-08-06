// To parse this JSON data, do
//
//     final generalReaderDispenserDataResponse = generalReaderDispenserDataResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

GeneralReaderDispenserDataResponse generalReaderDispenserDataResponseFromJson(
        String str) =>
    GeneralReaderDispenserDataResponse.fromJson(json.decode(str));

String generalReaderDispenserDataResponseToJson(
        GeneralReaderDispenserDataResponse data) =>
    json.encode(data.toJson());

class GeneralReaderDispenserDataResponse {
  bool ok;
  GeneralDispenserReader generalDispenserReader;

  GeneralReaderDispenserDataResponse({
    required this.ok,
    required this.generalDispenserReader,
  });

  factory GeneralReaderDispenserDataResponse.fromJson(
          Map<String, dynamic> json) =>
      GeneralReaderDispenserDataResponse(
        ok: json["ok"],
        generalDispenserReader:
            GeneralDispenserReader.fromJson(json["generalDispenserReader"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "generalDispenserReader": generalDispenserReader.toJson(),
      };
}
