// To parse this JSON data, do
//
//     final addNewReaderResponse = addNewReaderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/fuel.station/update.dispenser.reader.dart';

AddNewReaderResponse addNewReaderResponseFromJson(String str) =>
    AddNewReaderResponse.fromJson(json.decode(str));

String addNewReaderResponseToJson(AddNewReaderResponse data) =>
    json.encode(data.toJson());

class AddNewReaderResponse {
  bool ok;
  DispenserReader newDispenserReader;

  AddNewReaderResponse({
    required this.ok,
    required this.newDispenserReader,
  });

  factory AddNewReaderResponse.fromJson(Map<String, dynamic> json) =>
      AddNewReaderResponse(
        ok: json["ok"],
        newDispenserReader:
            DispenserReader.fromJson(json["newDispenserReader"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "newDispenserReader": newDispenserReader.toJson(),
      };
}
