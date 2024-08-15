class BankCheck {
  bool applied;
  int checkNumber;
  double checkValue;
  DateTime checkDate;
  Bank bankId;
  Client clientId;
  String salesControlId;
  String bankCheckId;

  BankCheck({
    required this.applied,
    required this.checkNumber,
    required this.checkValue,
    required this.checkDate,
    required this.bankId,
    required this.clientId,
    required this.salesControlId,
    required this.bankCheckId,
  });

  factory BankCheck.fromJson(Map<String, dynamic> json) => BankCheck(
        applied: json["applied"],
        checkNumber: json["checkNumber"],
        checkValue: json["checkValue"].toDouble(),
        checkDate: DateTime.parse(json["checkDate"]),
        bankId: Bank.fromJson(json["bankId"]),
        clientId: Client.fromJson(json["clientId"]),
        salesControlId: json["salesControlId"],
        bankCheckId: json["bankCheckId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "checkNumber": checkNumber,
        "checkValue": checkValue,
        "checkDate": checkDate.toIso8601String(),
        "bankId": bankId.toJson(),
        "clientId": clientId.toJson(),
        "salesControlId": salesControlId,
        "bankCheckId": bankCheckId,
      };
}

class Bank {
  String bankId;
  String bankName;
  String accountNumber;

  Bank({
    required this.bankId,
    required this.bankName,
    required this.accountNumber,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankId: json["bankId"] ?? '',
        bankName: json["bankName"] ?? '',
        accountNumber: json["accountNumber"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "bankId": bankId,
        "bankName": bankName,
        "accountNumber": accountNumber,
      };
}

class Client {
  String clientId;
  String clientName;
  String clientEmail;
  String clientPhone;
  String clientAddress;

  Client({
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAddress,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        clientId: json["clientId"] ?? '',
        clientName: json["clientName"] ?? '',
        clientEmail: json["clientEmail"] ?? '',
        clientPhone: json["clientPhone"] ?? '',
        clientAddress: json["clientAddress"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientPhone": clientPhone,
        "clientAddress": clientAddress,
      };
}
