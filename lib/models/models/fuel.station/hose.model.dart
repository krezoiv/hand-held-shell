import 'package:hand_held_shell/models/models/fuel.station/fuel.model.dart';

class Hose {
  String id;
  String hoseColor;
  Fuel fuelId;
  String statusId;

  int code;

  Hose({
    required this.id,
    required this.hoseColor,
    required this.fuelId,
    required this.statusId,
    required this.code,
  });

  factory Hose.fromJson(Map<String, dynamic> json) => Hose(
        id: json["_id"] ?? '',
        hoseColor: json["hoseColor"] ?? '',
        fuelId: Fuel.fromJson(json["fuelId"] ?? {}),
        statusId: json["statusId"] ?? '',
        code: json["code"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "hoseColor": hoseColor,
        "fuelId": fuelId.toJson(),
        "statusId": statusId,
        "code": code,
      };
}
