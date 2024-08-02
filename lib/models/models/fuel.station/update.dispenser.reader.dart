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
  AssignmentHoseId assignmentHoseId;
  String generalDispenserReaderId;
  String dispenserReaderId;

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
        "assignmentHoseId": assignmentHoseId.toJson(),
        "generalDispenserReaderId": generalDispenserReaderId,
        "dispenserReaderId": dispenserReaderId,
      };
}

class AssignmentHoseId {
  String id;
  int position;
  HoseId hoseId;
  SideId sideId;
  AssignmentId assignmentId;
  String statusId;

  AssignmentHoseId({
    required this.id,
    required this.position,
    required this.hoseId,
    required this.sideId,
    required this.assignmentId,
    required this.statusId,
  });

  factory AssignmentHoseId.fromJson(Map<String, dynamic> json) =>
      AssignmentHoseId(
        id: json["_id"] ?? '',
        position: json["position"] ?? 0,
        hoseId: HoseId.fromJson(json["hoseId"] ?? {}),
        sideId: SideId.fromJson(json["sideId"] ?? {}),
        assignmentId: AssignmentId.fromJson(json["assignmentId"] ?? {}),
        statusId: json["statusId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "position": position,
        "hoseId": hoseId.toJson(),
        "sideId": sideId.toJson(),
        "assignmentId": assignmentId.toJson(),
        "statusId": statusId,
      };
}

class AssignmentId {
  String id;
  DispenserId dispenserId;

  AssignmentId({
    required this.id,
    required this.dispenserId,
  });

  factory AssignmentId.fromJson(Map<String, dynamic> json) => AssignmentId(
        id: json["_id"] ?? '',
        dispenserId: DispenserId.fromJson(json["dispenserId"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dispenserId": dispenserId.toJson(),
      };
}

class DispenserId {
  String id;
  String dispenserCode;

  DispenserId({
    required this.id,
    required this.dispenserCode,
  });

  factory DispenserId.fromJson(Map<String, dynamic> json) => DispenserId(
        id: json["_id"] ?? '',
        dispenserCode: json["dispenserCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dispenserCode": dispenserCode,
      };
}

class HoseId {
  String id;
  String hoseColor;
  FuelId fuelId;
  String statusId;

  int code;

  HoseId({
    required this.id,
    required this.hoseColor,
    required this.fuelId,
    required this.statusId,
    required this.code,
  });

  factory HoseId.fromJson(Map<String, dynamic> json) => HoseId(
        id: json["_id"] ?? '',
        hoseColor: json["hoseColor"] ?? '',
        fuelId: FuelId.fromJson(json["fuelId"] ?? {}),
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

class FuelId {
  String id;
  String fuelName;

  FuelId({
    required this.id,
    required this.fuelName,
  });

  factory FuelId.fromJson(Map<String, dynamic> json) => FuelId(
        id: json["_id"] ?? '',
        fuelName: json["fuelName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fuelName": fuelName,
      };
}

class SideId {
  String id;
  String sideName;

  SideId({
    required this.id,
    required this.sideName,
  });

  factory SideId.fromJson(Map<String, dynamic> json) => SideId(
        id: json["_id"] ?? '',
        sideName: json["sideName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sideName": sideName,
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
        previousNoMechanic: (json["previousNoMechanic"] ?? 0).toDouble(),
        actualNoMechanic: json["actualNoMechanic"] ?? 0,
        totalNoMechanic: (json["totalNoMechanic"] ?? 0).toDouble(),
        previousNoMoney: (json["previousNoMoney"] ?? 0).toDouble(),
        actualNoMoney: json["actualNoMoney"] ?? 0,
        totalNoMoney: (json["totalNoMoney"] ?? 0).toDouble(),
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
  int totalGallonRegular;
  double totalMechanicRegular;
  double totalMoneyRegular;
  int totalGallonSuper;
  int totalMechanicSuper;
  int totalMoneySuper;
  int totalGallonDiesel;
  int totalMechanicDiesel;
  int totalMoneyDiesel;
  int totalGallonVpower;
  int totalMechanicVpower;
  int totalMoneyVpower;
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
        totalMechanicRegular: (json["totalMechanicRegular"] ?? 0).toDouble(),
        totalMoneyRegular: (json["totalMoneyRegular"] ?? 0).toDouble(),
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
