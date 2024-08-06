class GeneralDispenserReader {
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

  GeneralDispenserReader({
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

  factory GeneralDispenserReader.fromJson(Map<String, dynamic> json) =>
      GeneralDispenserReader(
        applied: json["applied"],
        totalGallonRegular: json["totalGallonRegular"].toDouble(),
        totalMechanicRegular: json["totalMechanicRegular"].toDouble(),
        totalMoneyRegular: json["totalMoneyRegular"],
        totalGallonSuper: json["totalGallonSuper"],
        totalMechanicSuper: json["totalMechanicSuper"].toDouble(),
        totalMoneySuper: json["totalMoneySuper"].toDouble(),
        totalGallonDiesel: json["totalGallonDiesel"],
        totalMechanicDiesel: json["totalMechanicDiesel"].toDouble(),
        totalMoneyDiesel: json["totalMoneyDiesel"].toDouble(),
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
