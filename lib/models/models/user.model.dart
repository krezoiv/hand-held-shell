import 'dart:convert';
import 'package:get/get.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String roleId;
  final String statusId;
  final bool online;
  final int? workShift;
  final String? userId;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.roleId,
    required this.statusId,
    this.online = false,
    this.workShift,
    this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json["firstName"] ?? '',
        lastName: json["lastName"] ?? '',
        email: json["email"] ?? '',
        roleId: json["roleId"] ?? '',
        statusId: json["statusId"] ?? '',
        online: json["online"] ?? false,
        workShift: json["workShift"] as int?,
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

  static UserModel fromJsonString(String str) =>
      UserModel.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? roleId,
    String? statusId,
    bool? online,
    int? workShift,
    String? userId,
  }) =>
      UserModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        roleId: roleId ?? this.roleId,
        statusId: statusId ?? this.statusId,
        online: online ?? this.online,
        workShift: workShift ?? this.workShift,
        userId: userId ?? this.userId,
      );
}

// Extensión para hacer el UserModel observable
extension UserModelRx on UserModel {
  Rx<UserModel> get obs => Rx<UserModel>(this);
}

// Funciones globales para mantener compatibilidad con el código existente
UserModel userModelFromJson(String str) => UserModel.fromJsonString(str);
String userModelToJson(UserModel data) => data.toJsonString();
