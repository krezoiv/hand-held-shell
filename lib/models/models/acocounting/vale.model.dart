import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Vale {
  int valeNumber;
  DateTime valeDate;
  num valeAmount;
  SalesControl salesControlId;
  String valeId;

  Vale({
    required this.valeNumber,
    required this.valeDate,
    required this.valeAmount,
    required this.salesControlId,
    required this.valeId,
  });

  factory Vale.fromJson(Map<String, dynamic> json) => Vale(
        valeNumber: json["valeNumber"],
        valeDate: DateTime.parse(json["valeDate"]),
        valeAmount: json["valeAmount"],
        salesControlId: SalesControl.fromJson(json["salesControlId"] ?? {}),
        valeId: json["valeId"],
      );

  Map<String, dynamic> toJson() => {
        "valeNumber": valeNumber,
        "valeDate": valeDate.toIso8601String(),
        "valeAmount": valeAmount,
        "salesControlId": salesControlId.toJson(),
        "valeId": valeId,
      };
}
