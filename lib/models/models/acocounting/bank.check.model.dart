import 'package:hand_held_shell/models/enteties.exports.files.dart';

class BankCheck {
  String id;
  int checkNumber;
  DateTime checkDate;
  Bank bankId;
  String clientId;

  BankCheck({
    required this.id,
    required this.checkNumber,
    required this.checkDate,
    required this.bankId,
    required this.clientId,
  });

  factory BankCheck.fromJson(Map<String, dynamic> json) => BankCheck(
        id: json["_id"],
        checkNumber: json["checkNumber"],
        checkDate: DateTime.parse(json["checkDate"]),
        bankId: Bank.fromJson(json["bankId"] ?? {}),
        // bankId: json["bankId"],
        clientId: json["clientId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "checkNumber": checkNumber,
        "checkDate": checkDate.toIso8601String(),
        "bankId": bankId.toJson(),
        "clientId": clientId,
      };
}
