import 'package:hand_held_shell/models/models/fuel.station/status/status.model.dart';
import 'package:hand_held_shell/models/models/taxes/taxes.model.dart';

class Fuel {
  String fuelName;
  double costPrice;
  double salePrice;
  Status statusId;
  Taxes taxesId;
  String fuelId;

  Fuel({
    required this.fuelName,
    required this.costPrice,
    required this.salePrice,
    required this.statusId,
    required this.taxesId,
    required this.fuelId,
  });

  factory Fuel.fromJson(Map<String, dynamic> json) => Fuel(
        fuelName: json["fuelName"],
        costPrice: json["costPrice"].toDouble(),
        salePrice: json["salePrice"].toDouble(),
        statusId: Status.fromJson(json["statusId"]),
        taxesId: Taxes.fromJson(json["taxesId"]),
        fuelId: json["fuelId"],
      );

  Map<String, dynamic> toJson() => {
        "fuelName": fuelName,
        "costPrice": costPrice,
        "salePrice": salePrice,
        "statusId": statusId.toJson(),
        "taxesId": taxesId.toJson(),
        "fuelId": fuelId,
      };
}
