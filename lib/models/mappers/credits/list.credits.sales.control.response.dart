// To parse this JSON data, do
//
//     final getCreditsListSaleControlResponse = getCreditsListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/credit.model.dart';

GetCreditsListSaleControlResponse getCreditsListSaleControlResponseFromJson(
        String str) =>
    GetCreditsListSaleControlResponse.fromJson(json.decode(str));

String getCreditsListSaleControlResponseToJson(
        GetCreditsListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetCreditsListSaleControlResponse {
  bool ok;
  List<Credit> credits;

  GetCreditsListSaleControlResponse({
    required this.ok,
    required this.credits,
  });

  factory GetCreditsListSaleControlResponse.fromJson(
          Map<String, dynamic> json) =>
      GetCreditsListSaleControlResponse(
        ok: json["ok"],
        credits:
            List<Credit>.from(json["credits"].map((x) => Credit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "credits": List<dynamic>.from(credits.map((x) => x.toJson())),
      };
}
