class Bill {
  String id;
  String billNumber;
  DateTime billDate;
  num billAmount;
  String billDescription;

  Bill({
    required this.id,
    required this.billNumber,
    required this.billDate,
    required this.billAmount,
    required this.billDescription,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        id: json["_id"],
        billNumber: json["billNumber"],
        billDate: DateTime.parse(json["billDate"]),
        billAmount: json["billAmount"],
        billDescription: json["billDescription"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "billNumber": billNumber,
        "billDate": billDate.toIso8601String(),
        "billAmount": billAmount,
        "billDescription": billDescription,
      };
}
