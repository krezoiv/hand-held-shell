class Voucher {
  String id;
  bool applied;
  int authorizationCode;
  String posId;
  num voucherAmount;
  DateTime voucherDate;

  Voucher({
    required this.id,
    required this.applied,
    required this.authorizationCode,
    required this.posId,
    required this.voucherAmount,
    required this.voucherDate,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["_id"],
        applied: json["applied"],
        authorizationCode: json["authorizationCode"],
        posId: json["posId"],
        voucherAmount: json["voucherAmount"],
        voucherDate: DateTime.parse(json["voucherDate"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "applied": applied,
        "authorizationCode": authorizationCode,
        "posId": posId,
        "voucherAmount": voucherAmount,
        "voucherDate": voucherDate.toIso8601String(),
      };
}
