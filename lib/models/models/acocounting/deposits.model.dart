import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Deposit {
  int depositNumber;
  num depositAmount;
  DateTime depositDate;
  Bank bankId;
  SalesControl salesControlId;
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
        salesControlId: SalesControl.fromJson(json["salesControlId"] ?? {}),
        depositId: json["depositId"],
      );

  Map<String, dynamic> toJson() => {
        "depositNumber": depositNumber,
        "depositAmount": depositAmount,
        "depositDate": depositDate.toIso8601String(),
        "bankId": bankId.toJson(),
        "salesControlId": salesControlId.toJson(),
        "depositId": depositId,
      };
}
