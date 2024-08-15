// To parse this JSON data, do
//
//     final getValesListSaleControlResponse = getValesListSaleControlResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/acocounting/vale.model.dart';

GetValesListSaleControlResponse getValesListSaleControlResponseFromJson(
        String str) =>
    GetValesListSaleControlResponse.fromJson(json.decode(str));

String getValesListSaleControlResponseToJson(
        GetValesListSaleControlResponse data) =>
    json.encode(data.toJson());

class GetValesListSaleControlResponse {
  bool ok;
  List<Vale> vales;

  GetValesListSaleControlResponse({
    required this.ok,
    required this.vales,
  });

  factory GetValesListSaleControlResponse.fromJson(Map<String, dynamic> json) =>
      GetValesListSaleControlResponse(
        ok: json["ok"],
        vales: List<Vale>.from(json["vales"].map((x) => Vale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "vales": List<dynamic>.from(vales.map((x) => x.toJson())),
      };
}
