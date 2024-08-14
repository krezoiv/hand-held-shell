import 'package:hand_held_shell/models/models/acocounting/pos.model.dart';

class Voucher {
  bool applied;
  String authorizationCode;
  Pos posId; // Mantén esto como Pos
  num voucherAmount;
  DateTime voucherDate;
  String salesControlId;
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
        applied: json["applied"] ?? false,
        authorizationCode: json["authorizationCode"] ?? '',
        posId: Pos.fromJson(
            json["posId"] ?? {}), // Asegúrate de que el mapeo esté correcto
        voucherAmount: json["voucherAmount"] ?? 0.0,
        voucherDate: json["voucherDate"] != null
            ? DateTime.parse(json["voucherDate"])
            : DateTime.now(),
        salesControlId: json["salesControlId"] ?? '',
        voucherId: json["voucherId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "authorizationCode": authorizationCode,
        "posId": posId.toJson(),
        "voucherAmount": voucherAmount,
        "voucherDate": voucherDate.toIso8601String(),
        "salesControlId": salesControlId,
        "voucherId": voucherId,
      };
}
