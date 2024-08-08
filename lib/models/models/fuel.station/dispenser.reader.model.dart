import 'package:hand_held_shell/models/enteties.exports.files.dart';

class DispenserReader {
  num previousNoGallons;
  num actualNoGallons;
  num totalNoGallons;
  num previousNoMechanic;
  num actualNoMechanic;
  num totalNoMechanic;
  num previousNoMoney;
  num actualNoMoney;
  num totalNoMoney;
  AssignmentHose assignmentHoseId;
  String generalDispenserReaderId; // Cambio a String
  String dispenserReaderId; // Cambio a String

  DispenserReader({
    required this.previousNoGallons,
    required this.actualNoGallons,
    required this.totalNoGallons,
    required this.previousNoMechanic,
    required this.actualNoMechanic,
    required this.totalNoMechanic,
    required this.previousNoMoney,
    required this.actualNoMoney,
    required this.totalNoMoney,
    required this.assignmentHoseId,
    required this.generalDispenserReaderId,
    required this.dispenserReaderId,
  });

  factory DispenserReader.fromJson(Map<String, dynamic> json) =>
      DispenserReader(
        previousNoGallons: json["previousNoGallons"] ?? 0,
        actualNoGallons: json["actualNoGallons"] ?? 0,
        totalNoGallons: json["totalNoGallons"] ?? 0,
        previousNoMechanic: json["previousNoMechanic"] ?? 0,
        actualNoMechanic: json["actualNoMechanic"] ?? 0,
        totalNoMechanic: json["totalNoMechanic"] ?? 0,
        previousNoMoney: json["previousNoMoney"] ?? 0,
        actualNoMoney: json["actualNoMoney"] ?? 0,
        totalNoMoney: json["totalNoMoney"] ?? 0,
        assignmentHoseId:
            AssignmentHose.fromJson(json["assignmentHoseId"] ?? {}),
        generalDispenserReaderId: json["generalDispenserReaderId"] ?? '',
        dispenserReaderId: json["dispenserReaderId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "previousNoGallons": previousNoGallons,
        "actualNoGallons": actualNoGallons,
        "totalNoGallons": totalNoGallons,
        "previousNoMechanic": previousNoMechanic,
        "actualNoMechanic": actualNoMechanic,
        "totalNoMechanic": totalNoMechanic,
        "previousNoMoney": previousNoMoney,
        "actualNoMoney": actualNoMoney,
        "totalNoMoney": totalNoMoney,
        "assignmentHoseId": assignmentHoseId.toJson(),
        "generalDispenserReaderId": generalDispenserReaderId,
        "dispenserReaderId": dispenserReaderId,
      };
}
