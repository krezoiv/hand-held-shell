// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String firstName;
  String lastName;
  String email;
  String roleId;
  String statusId;
  bool online;
  int? workShift; // Cambiado a nullable
  String? userId;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.roleId,
    required this.statusId,
    this.online = false,
    this.workShift, // Ahora es opcional
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        roleId: json["roleId"] ?? '',
        statusId: json["statusId"] ?? '',
        online: json["online"] ?? false,
        workShift:
            json["workShift"] as int?, // Usa 'as int?' para manejar nulos
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "roleId": roleId,
        "statusId": statusId,
        "online": online,
        "workShift": workShift,
        "userId": userId,
      };
}
