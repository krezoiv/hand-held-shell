class Voucher {
  bool applied;
  String authorizationCode;
  Pos posId;
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
        applied: json["applied"],
        authorizationCode: json["authorizationCode"],
        posId: Pos.fromJson(json["posId"] ?? {}),
        voucherAmount: json["voucherAmount"],
        voucherDate: DateTime.parse(json["voucherDate"]),
        salesControlId: json["salesControlId"],
        voucherId: json["voucherId"],
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

class Pos {
  String posId;
  String posName;

  Pos({
    required this.posId,
    required this.posName,
  });

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
        posId: json["posId"] ?? '', // Asegúrate de manejar los valores null
        posName: json["posName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "posId": posId,
        "posName": posName,
      };
}
