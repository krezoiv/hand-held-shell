import 'package:get/get.dart';

class Message {
  final String from;
  final String to;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String messageId;

  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.messageId,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"] ?? '',
        to: json["to"] ?? '',
        message: json["message"] ?? '',
        createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
        messageId: json["messageId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "messageId": messageId,
      };

  Message copyWith({
    String? from,
    String? to,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? messageId,
  }) =>
      Message(
        from: from ?? this.from,
        to: to ?? this.to,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        messageId: messageId ?? this.messageId,
      );
}

// Extensión para hacer el mensaje observable
extension MessageRx on Message {
  Rx<Message> get obs => Rx<Message>(this);
}
