class PurchaseOrder {
  bool applied;
  DateTime deliveryDate;
  DateTime orderDate;
  String orderNumber;
  String storeId;
  num totalGallonDiesel;
  num totalGallonRegular;
  num totalGallonSuper;
  num totalIdpPurchaseOrder;
  num totalPurchaseOrder;
  String turn;
  String userName;
  String vehicleId;
  String purchaseOrderId;

  PurchaseOrder({
    required this.applied,
    required this.deliveryDate,
    required this.orderDate,
    required this.orderNumber,
    required this.storeId,
    required this.totalGallonDiesel,
    required this.totalGallonRegular,
    required this.totalGallonSuper,
    required this.totalIdpPurchaseOrder,
    required this.totalPurchaseOrder,
    required this.turn,
    required this.userName,
    required this.vehicleId,
    required this.purchaseOrderId,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
        applied: json["applied"],
        deliveryDate: DateTime.parse(json["deliveryDate"]),
        orderDate: DateTime.parse(json["orderDate"]),
        orderNumber: json["orderNumber"],
        storeId: json["storeId"],
        totalGallonDiesel: json["totalGallonDiesel"],
        totalGallonRegular: json["totalGallonRegular"],
        totalGallonSuper: json["totalGallonSuper"],
        totalIdpPurchaseOrder: json["totalIDPPurchaseOrder"].toDouble(),
        totalPurchaseOrder: json["totalPurchaseOrder"].toDouble(),
        turn: json["turn"],
        userName: json["userName"],
        vehicleId: json["vehicleId"],
        purchaseOrderId: json["purchaseOrderId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "deliveryDate": deliveryDate.toIso8601String(),
        "orderDate": orderDate.toIso8601String(),
        "orderNumber": orderNumber,
        "storeId": storeId,
        "totalGallonDiesel": totalGallonDiesel,
        "totalGallonRegular": totalGallonRegular,
        "totalGallonSuper": totalGallonSuper,
        "totalIDPPurchaseOrder": totalIdpPurchaseOrder,
        "totalPurchaseOrder": totalPurchaseOrder,
        "turn": turn,
        "userName": userName,
        "vehicleId": vehicleId,
        "purchaseOrderId": purchaseOrderId,
      };
}
