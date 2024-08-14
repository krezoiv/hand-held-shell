class Pos {
  String posId;
  String posName;

  Pos({
    required this.posId,
    required this.posName,
  });

  factory Pos.fromJson(Map<String, dynamic> json) => Pos(
        posId: json["_id"] ?? '', // Asegúrate de manejar los valores null
        posName: json["posName"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": posId,
        "posName": posName,
      };
}
