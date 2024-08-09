class Client {
  String clientName;
  String clientEmail;
  String clientPhone;
  String clientAddress;
  String clientId;

  Client({
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAddress,
    required this.clientId,
  });

  // Método para crear una instancia de Client a partir de un JSON
  factory Client.fromJson(Map<String, dynamic> json) => Client(
        clientName: json["clientName"],
        clientEmail: json["clientEmail"],
        clientPhone: json["clientPhone"],
        clientAddress: json["clientAddress"],
        clientId: json["clientId"],
      );

  // Método para convertir una instancia de Client a JSON
  Map<String, dynamic> toJson() => {
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientPhone": clientPhone,
        "clientAddress": clientAddress,
        "clientId": clientId,
      };
}
