class DispenserReader {
  int previousNoGallons;
  int actualNoGallons;
  int totalNoGallons;
  int previousNoMechanic;
  int actualNoMechanic;
  int totalNoMechanic;
  int previousNoMoney;
  int actualNoMoney;
  int totalNoMoney;
  String assignmentHoseId;
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
        previousNoGallons: json["previousNoGallons"],
        actualNoGallons: json["actualNoGallons"],
        totalNoGallons: json["totalNoGallons"],
        previousNoMechanic: json["previousNoMechanic"],
        actualNoMechanic: json["actualNoMechanic"],
        totalNoMechanic: json["totalNoMechanic"],
        previousNoMoney: json["previousNoMoney"],
        actualNoMoney: json["actualNoMoney"],
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
