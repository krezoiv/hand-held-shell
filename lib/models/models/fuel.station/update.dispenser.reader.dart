class UpdatedDispenserReader {
  int previousNoGallons;
  int actualNoGallons;
  int totalNoGallons;
  double previousNoMechanic;
  double actualNoMechanic;
  int totalNoMechanic;
  double previousNoMoney;
  double actualNoMoney;
  int totalNoMoney;
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
        previousNoGallons: json["previousNoGallons"],
        actualNoGallons: json["actualNoGallons"],
        totalNoGallons: json["totalNoGallons"],
        previousNoMechanic: json["previousNoMechanic"].toDouble(),
        actualNoMechanic: json["actualNoMechanic"].toDouble(),
        totalNoMechanic: json["totalNoMechanic"],
        previousNoMoney: json["previousNoMoney"].toDouble(),
        actualNoMoney: json["actualNoMoney"].toDouble(),
        totalNoMoney: json["totalNoMoney"],
        assignmentHoseId: json["assignmentHoseId"],
        generalDispenserReaderId: json["generalDispenserReaderId"],
        dispenserReaderId: json["dispenserReaderId"],
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
  int totalMechanicRegular;
  int totalMoneyRegular;
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
        applied: json["applied"],
        totalGallonRegular: json["totalGallonRegular"],
        totalMechanicRegular: json["totalMechanicRegular"],
        totalMoneyRegular: json["totalMoneyRegular"],
        totalGallonSuper: json["totalGallonSuper"],
        totalMechanicSuper: json["totalMechanicSuper"],
        totalMoneySuper: json["totalMoneySuper"],
        totalGallonDiesel: json["totalGallonDiesel"],
        totalMechanicDiesel: json["totalMechanicDiesel"],
        totalMoneyDiesel: json["totalMoneyDiesel"],
        totalGallonVpower: json["totalGallonVpower"],
        totalMechanicVpower: json["totalMechanicVpower"],
        totalMoneyVpower: json["totalMoneyVpower"],
        readingDate: DateTime.parse(json["readingDate"]),
        generalDispenserReaderId: json["generalDispenserReaderId"],
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
