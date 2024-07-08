// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  bool ok;
  List<UserModel> users;

  UserResponse({
    required this.ok,
    required this.users,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        ok: json["ok"] ?? false,
        users: List<UserModel>.from(
            (json["users"] ?? []).map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}
