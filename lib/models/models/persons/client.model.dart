class Client {
  String clientId;
  String clientName;
  String clientEmail;
  String clientPhone;
  String clientAddress;

  Client({
    required this.clientId,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAddress,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        clientId: json["clientId"],
        clientName: json["clientName"],
        clientEmail: json["clientEmail"],
        clientPhone: json["clientPhone"],
        clientAddress: json["clientAddress"],
      );

  Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientPhone": clientPhone,
        "clientAddress": clientAddress,
      };
}
