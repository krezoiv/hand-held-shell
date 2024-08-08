class Dispenser {
  String id;
  String dispenserCode;

  Dispenser({
    required this.id,
    required this.dispenserCode,
  });

  factory Dispenser.fromJson(Map<String, dynamic> json) => Dispenser(
        id: json["_id"] ?? '',
        dispenserCode: json["dispenserCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dispenserCode": dispenserCode,
      };
}
