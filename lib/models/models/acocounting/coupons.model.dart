class Coupons {
  String id;
  bool applied;
  int cuponesNumber;
  DateTime cuponesDate;
  num cuponesAmount;

  Coupons({
    required this.id,
    required this.applied,
    required this.cuponesNumber,
    required this.cuponesDate,
    required this.cuponesAmount,
  });

  factory Coupons.fromJson(Map<String, dynamic> json) => Coupons(
        id: json["_id"],
        applied: json["applied"],
        cuponesNumber: json["cuponesNumber"],
        cuponesDate: DateTime.parse(json["cuponesDate"]),
        cuponesAmount: json["cuponesAmount"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "applied": applied,
        "cuponesNumber": cuponesNumber,
        "cuponesDate": cuponesDate.toIso8601String(),
        "cuponesAmount": cuponesAmount,
      };
}
