import 'package:hand_held_shell/models/enteties.exports.files.dart';

class Assignment {
  String id;
  Dispenser dispenserId;

  Assignment({
    required this.id,
    required this.dispenserId,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        id: json["_id"] ?? '',
        dispenserId: Dispenser.fromJson(json["dispenserId"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dispenserId": dispenserId.toJson(),
      };
}
