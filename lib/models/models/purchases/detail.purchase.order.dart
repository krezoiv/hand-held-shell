class DetailPurchaseOrder {
  num amount;
  num price;
  String fuelId;
  String purchaseOrderId;
  num idpTotal;
  num total;
  bool aplicado;

  String detailPurchaseOrderId;

  DetailPurchaseOrder({
    required this.amount,
    required this.price,
    required this.fuelId,
    required this.purchaseOrderId,
    required this.idpTotal,
    required this.total,
    required this.aplicado,
    required this.detailPurchaseOrderId,
  });

  factory DetailPurchaseOrder.fromJson(Map<String, dynamic> json) =>
      DetailPurchaseOrder(
        amount: json["amount"],
        price: json["price"].toDouble(),
        fuelId: json["fuelId"],
        purchaseOrderId: json["purchaseOrderId"],
        idpTotal: json["idpTotal"].toDouble(),
        total: json["total"].toDouble(),
        aplicado: json["aplicado"],
        detailPurchaseOrderId: json["detailPurchaseOrderId"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "price": price,
        "fuelId": fuelId,
        "purchaseOrderId": purchaseOrderId,
        "idpTotal": idpTotal,
        "total": total,
        "aplicado": aplicado,
        "detailPurchaseOrderId": detailPurchaseOrderId,
      };
}
