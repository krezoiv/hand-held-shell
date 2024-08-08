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

class UpdatedDispenserReader {
  num previousNoGallons;
  num actualNoGallons;
  num totalNoGallons;
  num previousNoMechanic;
  num actualNoMechanic;
  num totalNoMechanic;
  num previousNoMoney;
  num actualNoMoney;
  num totalNoMoney;
  String assignmentHoseId;
  String generalDispenserReaderId;

  String dispenserReaderId;

  UpdatedDispenserReader({
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

  factory UpdatedDispenserReader.fromJson(Map<String, dynamic> json) =>
      UpdatedDispenserReader(
        previousNoGallons: json["previousNoGallons"] ?? 0,
        actualNoGallons: json["actualNoGallons"] ?? 0,
        totalNoGallons: json["totalNoGallons"] ?? 0,
        previousNoMechanic: json["previousNoMechanic"] ?? 0,
        actualNoMechanic: json["actualNoMechanic"] ?? 0,
        totalNoMechanic: json["totalNoMechanic"] ?? 0,
        previousNoMoney: json["previousNoMoney"] ?? 0,
        actualNoMoney: json["actualNoMoney"] ?? 0,
        totalNoMoney: json["totalNoMoney"] ?? 0,
        assignmentHoseId: json["assignmentHoseId"] ?? '',
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
        "assignmentHoseId": assignmentHoseId,
        "generalDispenserReaderId": generalDispenserReaderId,
        "dispenserReaderId": dispenserReaderId,
      };
}

class UpdatedGeneralDispenserReader {
  bool applied;
  num totalGallonRegular;
  num totalMechanicRegular;
  num totalMoneyRegular;
  num totalGallonSuper;
  num totalMechanicSuper;
  num totalMoneySuper;
  num totalGallonDiesel;
  num totalMechanicDiesel;
  num totalMoneyDiesel;
  num totalGallonVpower;
  num totalMechanicVpower;
  num totalMoneyVpower;
  DateTime readingDate;

  String generalDispenserReaderId;

  UpdatedGeneralDispenserReader({
    required this.applied,
    required this.totalGallonRegular,
    required this.totalMechanicRegular,
    required this.totalMoneyRegular,
    required this.totalGallonSuper,
    required this.totalMechanicSuper,
    required this.totalMoneySuper,
    required this.totalGallonDiesel,
    required this.totalMechanicDiesel,
    required this.totalMoneyDiesel,
    required this.totalGallonVpower,
    required this.totalMechanicVpower,
    required this.totalMoneyVpower,
    required this.readingDate,
    required this.generalDispenserReaderId,
  });

  factory UpdatedGeneralDispenserReader.fromJson(Map<String, dynamic> json) =>
      UpdatedGeneralDispenserReader(
        applied: json["applied"] ?? false,
        totalGallonRegular: json["totalGallonRegular"] ?? 0,
        totalMechanicRegular: json["totalMechanicRegular"] ?? 0,
        totalMoneyRegular: json["totalMoneyRegular"] ?? 0,
        totalGallonSuper: json["totalGallonSuper"] ?? 0,
        totalMechanicSuper: json["totalMechanicSuper"] ?? 0,
        totalMoneySuper: json["totalMoneySuper"] ?? 0,
        totalGallonDiesel: json["totalGallonDiesel"] ?? 0,
        totalMechanicDiesel: json["totalMechanicDiesel"] ?? 0,
        totalMoneyDiesel: json["totalMoneyDiesel"] ?? 0,
        totalGallonVpower: json["totalGallonVpower"] ?? 0,
        totalMechanicVpower: json["totalMechanicVpower"] ?? 0,
        totalMoneyVpower: json["totalMoneyVpower"] ?? 0,
        readingDate: DateTime.parse(
            json["readingDate"] ?? DateTime.now().toIso8601String()),
        generalDispenserReaderId: json["generalDispenserReaderId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "totalGallonRegular": totalGallonRegular,
        "totalMechanicRegular": totalMechanicRegular,
        "totalMoneyRegular": totalMoneyRegular,
        "totalGallonSuper": totalGallonSuper,
        "totalMechanicSuper": totalMechanicSuper,
        "totalMoneySuper": totalMoneySuper,
        "totalGallonDiesel": totalGallonDiesel,
        "totalMechanicDiesel": totalMechanicDiesel,
        "totalMoneyDiesel": totalMoneyDiesel,
        "totalGallonVpower": totalGallonVpower,
        "totalMechanicVpower": totalMechanicVpower,
        "totalMoneyVpower": totalMoneyVpower,
        "readingDate": readingDate.toIso8601String(),
        "generalDispenserReaderId": generalDispenserReaderId,
      };
}
