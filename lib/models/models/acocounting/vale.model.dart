// ignore: unused_import
import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Vale {
  String valeNumber;
  DateTime valeDate;
  num valeAmount;
  String valeDescription;
  String salesControlId;
  String valeId;

  Vale({
    required this.valeNumber,
    required this.valeDate,
    required this.valeAmount,
    required this.valeDescription,
    required this.salesControlId,
    required this.valeId,
  });

  factory Vale.fromJson(Map<String, dynamic> json) => Vale(
        valeNumber: json["valeNumber"],
        valeDate: DateTime.parse(json["valeDate"]),
        valeAmount: json["valeAmount"],
        valeDescription: json["valeDescription"],
        salesControlId: json["salesControlId"],
        valeId: json["valeId"],
      );

  Map<String, dynamic> toJson() => {
        "valeNumber": valeNumber,
        "valeDate": valeDate.toIso8601String(),
        "valeAmount": valeAmount,
        "valeDescription": valeDescription,
        "salesControlId": salesControlId,
        "valeId": valeId,
      };
}
