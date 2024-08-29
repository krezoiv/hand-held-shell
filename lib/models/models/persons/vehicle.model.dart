class Vehicle {
  String vehicleName;
  String driver;

  String vehicleId;

  Vehicle({
    required this.vehicleName,
    required this.driver,
    required this.vehicleId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleName: json["vehicleName"],
        driver: json["driver"],
        vehicleId: json["vehicleId"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleName": vehicleName,
        "driver": driver,
        "vehicleId": vehicleId,
      };
}
