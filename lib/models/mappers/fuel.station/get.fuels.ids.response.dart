// To parse this JSON data, do
//
//     final getFuelsIdsResponse = getFuelsIdsResponseFromJson(jsonString);

import 'dart:convert';

GetFuelsIdsResponse getFuelsIdsResponseFromJson(String str) =>
    GetFuelsIdsResponse.fromJson(json.decode(str));

String getFuelsIdsResponseToJson(GetFuelsIdsResponse data) =>
    json.encode(data.toJson());

class GetFuelsIdsResponse {
  bool ok;
  FuelIds fuelIds;

  GetFuelsIdsResponse({
    required this.ok,
    required this.fuelIds,
  });

  factory GetFuelsIdsResponse.fromJson(Map<String, dynamic> json) =>
      GetFuelsIdsResponse(
        ok: json["ok"],
        fuelIds: FuelIds.fromJson(json["fuelIds"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "fuelIds": fuelIds.toJson(),
      };
}

class FuelIds {
  String regular;
  String fuelIdsSuper;
  String diesel;

  FuelIds({
    required this.regular,
    required this.fuelIdsSuper,
    required this.diesel,
  });

  factory FuelIds.fromJson(Map<String, dynamic> json) => FuelIds(
        regular: json["regular"],
        fuelIdsSuper: json["super"],
        diesel: json["diesel"],
      );

  Map<String, dynamic> toJson() => {
        "regular": regular,
        "super": fuelIdsSuper,
        "diesel": diesel,
      };
}
