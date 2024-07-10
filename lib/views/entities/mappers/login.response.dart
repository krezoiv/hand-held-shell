import 'dart:convert';

import 'package:hand_held_shell/views/entities/models/user.model.dart';

class LoginResponse {
  final bool ok;
  final UserModel user;
  final String token;

  LoginResponse({
    required this.ok,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"] ?? false,
        user: UserModel.fromJson(json["user"] ?? {}),
        token: json["token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "user": user.toJson(),
        "token": token,
      };

  static LoginResponse fromJsonString(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

// // To parse this JSON data, do
// //
// //     final loginResponse = loginResponseFromJson(jsonString);

// import 'dart:convert';

// import 'package:hand_held_shell/views/entities/enteties.exports.files.dart';
// import 'package:hand_held_shell/views/entities/models/user.model.dart';

// LoginResponse loginResponseFromJson(String str) =>
//     LoginResponse.fromJson(json.decode(str));

// String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

// class LoginResponse {
//   bool? ok;
//   UserModel? user;
//   String? token;

//   LoginResponse({
//     this.ok,
//     this.user,
//     this.token,
//   });

//   factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
//         ok: json["ok"],
//         user: UserModel.fromJson(json["user"]),
//         token: json["token"],
//       );

//   Map<String, dynamic> toJson() => {
//         "ok": ok,
//         "user": user?.toJson(),
//         "token": token,
//       };
// }
