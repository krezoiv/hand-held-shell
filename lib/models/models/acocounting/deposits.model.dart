class Deposit {
  int depositNumber;
  num depositAmount;
  DateTime depositDate;
  Bank bankId;
  String salesControlId;
  String depositId;

  Deposit({
    required this.depositNumber,
    required this.depositAmount,
    required this.depositDate,
    required this.bankId,
    required this.salesControlId,
    required this.depositId,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
        depositNumber: json["depositNumber"],
        depositAmount: json["depositAmount"],
        depositDate: DateTime.parse(json["depositDate"]),
        bankId: Bank.fromJson(json["bankId"] ?? {}),
        salesControlId: json["salesControlId"],
        depositId: json["depositId"],
      );

  Map<String, dynamic> toJson() => {
        "depositNumber": depositNumber,
        "depositAmount": depositAmount,
        "depositDate": depositDate.toIso8601String(),
        "bankId": bankId.toJson(),
        "salesControlId": salesControlId,
        "depositId": depositId,
      };
}

class Bank {
  String id;
  String bankName;
  String accountNumber;

  Bank({
    required this.id,
    required this.bankName,
    required this.accountNumber,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json["_id"] ?? '',
        bankName: json["bankName"] ?? '',
        accountNumber: json["accountNumber"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bankName": bankName,
        "accountNumber": accountNumber,
      };
}
