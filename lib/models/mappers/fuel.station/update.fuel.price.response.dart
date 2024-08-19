// To parse this JSON data, do
//
//     final updateFuelPriceResponse = updateFuelPriceResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';

UpdateFuelPriceResponse updateFuelPriceResponseFromJson(String str) =>
    UpdateFuelPriceResponse.fromJson(json.decode(str));

String updateFuelPriceResponseToJson(UpdateFuelPriceResponse data) =>
    json.encode(data.toJson());

class UpdateFuelPriceResponse {
  bool ok;
  String msg;
  Fuel updatedRegular;
  Fuel updatedSuper;
  Fuel updatedDiesel;

  UpdateFuelPriceResponse({
    required this.ok,
    required this.msg,
    required this.updatedRegular,
    required this.updatedSuper,
    required this.updatedDiesel,
  });

  factory UpdateFuelPriceResponse.fromJson(Map<String, dynamic> json) =>
      UpdateFuelPriceResponse(
        ok: json["ok"],
        msg: json["msg"],
        updatedRegular: Fuel.fromJson(json["updatedRegular"]),
        updatedSuper: Fuel.fromJson(json["updatedSuper"]),
        updatedDiesel: Fuel.fromJson(json["updatedDiesel"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "updatedRegular": updatedRegular.toJson(),
        "updatedSuper": updatedSuper.toJson(),
        "updatedDiesel": updatedDiesel.toJson(),
      };
}
