import 'package:hand_held_shell/models/enteties.exports.files.dart';

class AssignmentHose {
  String id;
  int position;
  Hose hoseId;
  Side sideId;
  Assignment assignmentId;
  String statusId;

  AssignmentHose({
    required this.id,
    required this.position,
    required this.hoseId,
    required this.sideId,
    required this.assignmentId,
    required this.statusId,
  });

  factory AssignmentHose.fromJson(Map<String, dynamic> json) => AssignmentHose(
        id: json["_id"] ?? '',
        position: json["position"] ?? 0,
        hoseId: Hose.fromJson(json["hoseId"] ?? {}),
        sideId: Side.fromJson(json["sideId"] ?? {}),
        assignmentId: Assignment.fromJson(json["assignmentId"] ?? {}),
        statusId: json["statusId"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "position": position,
        "hoseId": hoseId.toJson(),
        "sideId": sideId.toJson(),
        "assignmentId": assignmentId.toJson(),
        "statusId": statusId,
      };
}
