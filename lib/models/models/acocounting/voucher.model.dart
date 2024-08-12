import 'package:hand_held_shell/models/enteties.exports.files.dart';

class Voucher {
  bool applied;
  String authorizationCode;
  Pos posId;
  num voucherAmount;
  DateTime voucherDate;
  SalesControl salesControlId;
  String voucherId;

  Voucher({
    required this.applied,
    required this.authorizationCode,
    required this.posId,
    required this.voucherAmount,
    required this.voucherDate,
    required this.salesControlId,
    required this.voucherId,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        applied: json["applied"],
        authorizationCode: json["authorizationCode"],
        posId: Pos.fromJson(json["posId"] ?? {}),
        voucherAmount: json["voucherAmount"],
        voucherDate: DateTime.parse(json["voucherDate"]),
        salesControlId: SalesControl.fromJson(json["salesControlId"] ?? {}),
        voucherId: json["voucherId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "authorizationCode": authorizationCode,
        "posId": posId.toJson(),
        "voucherAmount": voucherAmount,
        "voucherDate": voucherDate.toIso8601String(),
        "salesControlId": salesControlId.toJson(),
        "voucherId": voucherId,
      };
}
