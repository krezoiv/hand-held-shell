import 'dart:convert';

import 'package:hand_held_shell/models/models/fuel.station/update.dispenser.reader.dart';

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
  List<DispenserReader> dispenserReaders;

  UpdateReaderDispenserResponse({
    required this.ok,
    required this.msg,
    required this.updatedDispenserReader,
    required this.updatedGeneralDispenserReader,
    required this.dispenserReaders,
  });

  factory UpdateReaderDispenserResponse.fromJson(Map<String, dynamic> json) =>
      UpdateReaderDispenserResponse(
        ok: json["ok"] ?? false,
        msg: json["msg"] ?? '',
        updatedDispenserReader: UpdatedDispenserReader.fromJson(
            json["updatedDispenserReader"] ?? {}),
        updatedGeneralDispenserReader: UpdatedGeneralDispenserReader.fromJson(
            json["updatedGeneralDispenserReader"] ?? {}),
        dispenserReaders: List<DispenserReader>.from(
            (json["dispenserReaders"] ?? [])
                .map((x) => DispenserReader.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "updatedDispenserReader": updatedDispenserReader.toJson(),
        "updatedGeneralDispenserReader": updatedGeneralDispenserReader.toJson(),
        "dispenserReaders":
            List<dynamic>.from(dispenserReaders.map((x) => x.toJson())),
      };
}
