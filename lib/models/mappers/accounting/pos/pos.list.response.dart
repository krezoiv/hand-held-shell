// To parse this JSON data, do
//
//     final posListResponse = posListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

PosListResponse posListResponseFromJson(String str) =>
    PosListResponse.fromJson(json.decode(str));

String posListResponseToJson(PosListResponse data) =>
    json.encode(data.toJson());

class PosListResponse {
  bool ok;
  List<Pos> pos;

  PosListResponse({
    required this.ok,
    required this.pos,
  });

  factory PosListResponse.fromJson(Map<String, dynamic> json) =>
      PosListResponse(
        ok: json["ok"],
        pos: List<Pos>.from(json["pos"].map((x) => Pos.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "pos": List<dynamic>.from(pos.map((x) => x.toJson())),
      };
}
