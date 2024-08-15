import 'package:hand_held_shell/models/models/sales/sales.control.model.dart';

class Credit {
  bool applied;
  int creditNumber;
  num creditAmount;
  DateTime creditDate;
  num regularAmount;
  num superAmount;
  num dieselAmount;
  Client clientId;
  String salesControlId;
  String creditId;

  Credit({
    required this.applied,
    required this.creditNumber,
    required this.creditAmount,
    required this.creditDate,
    required this.regularAmount,
    required this.superAmount,
    required this.dieselAmount,
    required this.clientId,
    required this.salesControlId,
    required this.creditId,
  });

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        applied: json["applied"],
        creditNumber: json["creditNumber"],
        creditAmount: json["creditAmount"],
        creditDate: DateTime.parse(json["creditDate"]),
        regularAmount: json["regularAmount"],
        superAmount: json["superAmount"],
        dieselAmount: json["dieselAmount"],
        clientId: Client.fromJson(json["clientId"] ?? {}),
        salesControlId: json["salesControlId"],
        creditId: json["creditId"],
      );

  Map<String, dynamic> toJson() => {
        "applied": applied,
        "creditNumber": creditNumber,
        "creditAmount": creditAmount,
        "creditDate": creditDate.toIso8601String(),
        "regularAmount": regularAmount,
        "superAmount": superAmount,
        "dieselAmount": dieselAmount,
        "clientId": clientId.toJson(),
        "salesControlId": salesControlId,
        "creditId": creditId,
      };
}

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
        clientId: json["clientId"] ?? "",
        clientName: json["clientName"] ?? "",
        clientEmail: json["clientEmail"] ?? "",
        clientPhone: json["clientPhone"] ?? "",
        clientAddress: json["clientAddress"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "clientId": clientId,
        "clientName": clientName,
        "clientEmail": clientEmail,
        "clientPhone": clientPhone,
        "clientAddress": clientAddress,
      };
}
