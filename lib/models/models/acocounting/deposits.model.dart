class Deposits {
  String id;
  int depositNumber;
  num depositAmount;
  DateTime depositDate;
  String bankId;

  Deposits({
    required this.id,
    required this.depositNumber,
    required this.depositAmount,
    required this.depositDate,
    required this.bankId,
  });

  factory Deposits.fromJson(Map<String, dynamic> json) => Deposits(
        id: json["_id"],
        depositNumber: json["depositNumber"],
        depositAmount: json["depositAmount"],
        depositDate: DateTime.parse(json["depositDate"]),
        bankId: json["bankId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "depositNumber": depositNumber,
        "depositAmount": depositAmount,
        "depositDate": depositDate.toIso8601String(),
        "bankId": bankId,
      };
}
