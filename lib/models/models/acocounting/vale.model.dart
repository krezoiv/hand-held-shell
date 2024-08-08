class Vale {
  String id;
  int valeNumber;
  DateTime valeDate;
  num valeAmount;

  Vale({
    required this.id,
    required this.valeNumber,
    required this.valeDate,
    required this.valeAmount,
  });

  factory Vale.fromJson(Map<String, dynamic> json) => Vale(
        id: json["_id"],
        valeNumber: json["valeNumber"],
        valeDate: DateTime.parse(json["valeDate"]),
        valeAmount: json["valeAmount"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "valeNumber": valeNumber,
        "valeDate": valeDate.toIso8601String(),
        "valeAmount": valeAmount,
      };
}
