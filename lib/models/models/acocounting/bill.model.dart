class Bill {
  String billNumber;
  DateTime billDate;
  num billAmount;
  String billDescription;
  String salesControlId; // Cambiado de SalesControl a String
  String billId;

  Bill({
    required this.billNumber,
    required this.billDate,
    required this.billAmount,
    required this.billDescription,
    required this.salesControlId, // Cambiado de SalesControl a String
    required this.billId,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
        billNumber: json["billNumber"],
        billDate: DateTime.parse(json["billDate"]),
        billAmount: json["billAmount"],
        billDescription: json["billDescription"],
        salesControlId: json["salesControlId"], // Aquí se asigna directamente
        billId: json["billId"],
      );

  Map<String, dynamic> toJson() => {
        "billNumber": billNumber,
        "billDate": billDate.toIso8601String(),
        "billAmount": billAmount,
        "billDescription": billDescription,
        "salesControlId": salesControlId, // Aquí se convierte directamente
        "billId": billId,
      };
}
