import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Credit {
  bool applied;
  int creditNumber;
  num creditAmount;
  DateTime creditDate;
  Client clientId;
  SalesControl salesControlId;
  String creditId;

  Credit({
    required this.applied,
    required this.creditNumber,
    required this.creditAmount,
    required this.creditDate,
    required this.clientId,
    required this.salesControlId,
    required this.creditId,
  });

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        applied: json["applied"],
        creditNumber: json["creditNumber"],
        creditAmount: json["creditAmount"],
        creditDate: DateTime.parse(json["creditDate"]),
        clientId: Client.fromJson(json["clientId"] ?? {}),
        salesControlId: SalesControl.fromJson(json["salesControlId"] ?? {}),
        creditId: json["creditId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "creditNumber": creditNumber,
        "creditAmount": creditAmount,
        "creditDate": creditDate.toIso8601String(),
        "clientId": clientId.toJson(),
        "salesControlId": salesControlId.toJson(),
        "creditId": creditId,
      };
}
