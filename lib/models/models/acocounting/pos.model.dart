class Pos {
  String posName;
  String posId;

  Pos({
    required this.posName,
    required this.posId,
  });

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
        posName: json["posName"],
        posId: json["posId"],
      );

  Map<String, dynamic> toJson() => {
        "posName": posName,
        "posId": posId,
      };
}
