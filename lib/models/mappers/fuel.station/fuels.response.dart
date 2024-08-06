// To parse this JSON data, do
//
//     final fuelsDataResponse = fuelsDataResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';

FuelsDataResponse fuelsDataResponseFromJson(String str) =>
    FuelsDataResponse.fromJson(json.decode(str));

String fuelsDataResponseToJson(FuelsDataResponse data) =>
    json.encode(data.toJson());

class FuelsDataResponse {
  bool ok;
  List<Fuel> fuels;

  FuelsDataResponse({
    required this.ok,
    required this.fuels,
  });

  factory FuelsDataResponse.fromJson(Map<String, dynamic> json) =>
      FuelsDataResponse(
        ok: json["ok"],
        fuels: List<Fuel>.from(json["fuels"].map((x) => Fuel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "fuels": List<dynamic>.from(fuels.map((x) => x.toJson())),
      };
}
