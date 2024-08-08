class Credit {
  String id;
  bool applied;
  int creditNumber;
  num creditAmount;
  DateTime creditDate;
  String clientId;

  Credit({
    required this.id,
    required this.applied,
    required this.creditNumber,
    required this.creditAmount,
    required this.creditDate,
    required this.clientId,
  });

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        id: json["_id"],
        applied: json["applied"],
        creditNumber: json["creditNumber"],
        creditAmount: json["creditAmount"],
        creditDate: DateTime.parse(json["creditDate"]),
        clientId: json["clientId"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "applied": applied,
        "creditNumber": creditNumber,
        "creditAmount": creditAmount,
        "creditDate": creditDate.toIso8601String(),
        "clientId": clientId,
      };
}
