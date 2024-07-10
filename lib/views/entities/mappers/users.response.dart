import 'dart:convert';
import 'package:get/get.dart';
import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';

class UserResponse {
  final bool ok;
  final List<UserModel> users;

  UserResponse({
    required this.ok,
    required this.users,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        ok: json["ok"] ?? false,
        users: List<UserModel>.from((json["users"] as List<dynamic>? ?? [])
            .map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": users.map((x) => x.toJson()).toList(),
      };

  static UserResponse fromJsonString(String str) =>
      UserResponse.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

// Extensión para hacer la lista de usuarios observable
extension UserResponseRx on UserResponse {
  Rx<UserResponse> get obs => Rx<UserResponse>(this);
}
