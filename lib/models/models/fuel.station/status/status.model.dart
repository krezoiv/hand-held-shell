class Status {
  String id;
  String statusName;

  Status({
    required this.id,
    required this.statusName,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["_id"],
        statusName: json["statusName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "statusName": statusName,
      };
}
