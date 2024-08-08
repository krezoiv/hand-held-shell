class Side {
  String id;
  String sideName;

  Side({
    required this.id,
    required this.sideName,
  });

  factory Side.fromJson(Map<String, dynamic> json) => Side(
        id: json["_id"] ?? '',
        sideName: json["sideName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sideName": sideName,
      };
}
