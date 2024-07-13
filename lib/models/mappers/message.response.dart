import 'dart:convert';

import 'package:hand_held_shell/models/enteties.exports.files.dart';

class MessageResponse {
  final bool ok;
  final List<Message> messages;

  MessageResponse({
    required this.ok,
    required this.messages,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        ok: json["ok"] ?? false,
        messages: (json["messages"] as List<dynamic>?)
                ?.map((x) => Message.fromJson(x))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": messages.map((x) => x.toJson()).toList(),
      };

  static MessageResponse fromJsonString(String str) =>
      MessageResponse.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}
