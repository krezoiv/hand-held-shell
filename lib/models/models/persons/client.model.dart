class Client {
  String id;
  String clientName;
  String clientEmail;
  String clientPhone;
  String clientAddress;

  Client({
    required this.id,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAddress,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["_id"],
        clientName: json["clientName"],
        clientEmail: json["clientEmail"],
        clientPhone: json["clientPhone"],
        clientAddress: json["clientAddress"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientPhone": clientPhone,
        "clientAddress": clientAddress,
      };
}
