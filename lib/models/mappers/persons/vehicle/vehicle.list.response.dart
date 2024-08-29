// To parse this JSON data, do
//
//     final vehiclesListResponse = vehiclesListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

VehiclesListResponse vehiclesListResponseFromJson(String str) =>
    VehiclesListResponse.fromJson(json.decode(str));

String vehiclesListResponseToJson(VehiclesListResponse data) =>
    json.encode(data.toJson());

class VehiclesListResponse {
  bool ok;
  List<Vehicle> vehicles;
  String message;

  VehiclesListResponse({
    required this.ok,
    required this.vehicles,
    required this.message,
  });

  factory VehiclesListResponse.fromJson(Map<String, dynamic> json) =>
      VehiclesListResponse(
        ok: json["ok"],
        vehicles: List<Vehicle>.from(
            json["vehicles"].map((x) => Vehicle.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
        "message": message,
      };
}
