// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? firstName;
  String? lastName;
  String? email;
  String? roleId;
  String? statusId;
  bool online;
  int? workShift;
  int? v;
  String? userId;

  UserModel({
    this.firstName,
    this.lastName,
    this.email,
    this.roleId,
    this.statusId,
    this.online = false,
    this.workShift,
    this.v,
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        roleId: json["roleId"],
        statusId: json["statusId"],
        online: json["online"],
        workShift: json["workShift"],
        v: json["__v"],
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
        "__v": v,
        "userId": userId,
      };
}
