import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Bill {
  String billNumber;
  DateTime billDate;
  int billAmount;
  String billDescription;
  SalesControl salesControlId;
  String billId;

  Bill({
    required this.billNumber,
    required this.billDate,
    required this.billAmount,
    required this.billDescription,
    required this.salesControlId,
    required this.billId,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        billNumber: json["billNumber"],
        billDate: DateTime.parse(json["billDate"]),
        billAmount: json["billAmount"],
        billDescription: json["billDescription"],
        salesControlId: SalesControl.fromJson(json["salesControlId"] ?? {}),
        billId: json["billId"],
      );

  Map<String, dynamic> toJson() => {
        "billNumber": billNumber,
        "billDate": billDate.toIso8601String(),
        "billAmount": billAmount,
        "billDescription": billDescription,
        "salesControlId": salesControlId.toJson(),
        "billId": billId,
      };
}
