// To parse this JSON data, do
//
//     final clientkListResponse = clientkListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

ClientListResponse clientkListResponseFromJson(String str) =>
    ClientListResponse.fromJson(json.decode(str));

String clientkListResponseToJson(ClientListResponse data) =>
    json.encode(data.toJson());

class ClientListResponse {
  bool ok;
  List<Client> clients;
  String message;

  ClientListResponse({
    required this.ok,
    required this.clients,
    required this.message,
  });

  factory ClientListResponse.fromJson(Map<String, dynamic> json) =>
      ClientListResponse(
        ok: json["ok"],
        clients:
            List<Client>.from(json["clients"].map((x) => Client.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "clients": List<dynamic>.from(clients.map((x) => x.toJson())),
        "message": message,
      };
}
