import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Coupon {
  bool applied;
  String cuponesNumber;
  DateTime cuponesDate;
  num cuponesAmount;
  String salesControlId;
  String couponId;

  Coupon({
    required this.applied,
    required this.cuponesNumber,
    required this.cuponesDate,
    required this.cuponesAmount,
    required this.salesControlId,
    required this.couponId,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        applied: json["applied"],
        cuponesNumber: json["cuponesNumber"],
        cuponesDate: DateTime.parse(json["cuponesDate"]),
        cuponesAmount: json["cuponesAmount"],
        salesControlId: json["salesControlId"],
        couponId: json["couponId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "cuponesNumber": cuponesNumber,
        "cuponesDate": cuponesDate.toIso8601String(),
        "cuponesAmount": cuponesAmount,
        "salesControlId": salesControlId,
        "couponId": couponId,
      };
}
