class Taxes {
  String id;
  String idpName;
  double idpAmount;

  Taxes({
    required this.id,
    required this.idpName,
    required this.idpAmount,
  });

  factory Taxes.fromJson(Map<String, dynamic> json) => Taxes(
        id: json["_id"],
        idpName: json["idpName"],
        idpAmount: json["idpAmount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "idpName": idpName,
        "idpAmount": idpAmount,
      };
}
