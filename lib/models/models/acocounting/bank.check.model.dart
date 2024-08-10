import 'package:hand_held_shell/models/enteties.exports.files.dart';

class BankCheck {
  bool applied;
  int checkNumber;
  num checkValue;
  DateTime checkDate;
  Bank bankId;
  Client clientId;
  SalesControl salesControlId;
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
        checkValue: json["checkValue"],
        checkDate: DateTime.parse(json["checkDate"]),
        bankId: Bank.fromJson(json["bankId"] ?? {}),
        clientId: Client.fromJson(json["clientId"] ?? {}),
        salesControlId: SalesControl.fromJson(json["salesControlId"] ?? {}),
        bankCheckId: json["bankCheckId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "checkNumber": checkNumber,
        "checkValue": checkValue,
        "checkDate": checkDate.toIso8601String(),
        "bankId": bankId.toJson(),
        "clientId": clientId.toJson(),
        "salesControlId": salesControlId.toJson(),
        "bankCheckId": bankCheckId,
      };
}
