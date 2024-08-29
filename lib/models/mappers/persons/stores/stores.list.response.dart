// To parse this JSON data, do
//
//     final storesListResponse = storesListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/models/persons/store.model.dart';

StoresListResponse storesListResponseFromJson(String str) =>
    StoresListResponse.fromJson(json.decode(str));

String storesListResponseToJson(StoresListResponse data) =>
    json.encode(data.toJson());

class StoresListResponse {
  bool ok;
  List<Store> stores;
  String message;

  StoresListResponse({
    required this.ok,
    required this.stores,
    required this.message,
  });

  factory StoresListResponse.fromJson(Map<String, dynamic> json) =>
      StoresListResponse(
        ok: json["ok"],
        stores: List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "stores": List<dynamic>.from(stores.map((x) => x.toJson())),
        "message": message,
      };
}
