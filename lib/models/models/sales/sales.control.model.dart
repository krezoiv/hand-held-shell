import 'package:hand_held_shell/models/enteties.exports.files.dart';

class SalesControl {
  DateTime salesDate;
  int noDocument;
  num regularPrice;
  num superPrice;
  num dieselPrice;
  num totalGallonRegular;
  num totalGallonSuper;
  num totalGallonDiesel;
  num regularAccumulatedGallons;
  num superAccumulatedGallons;
  num dieselAccumulatedGallons;
  num total;
  num balance;
  num totalAbonosBalance;
  List<dynamic> billIds;
  List<dynamic> valeIds;
  List<dynamic> couponsIds;
  List<dynamic> voucherIds;
  List<dynamic> depositsIds;
  List<dynamic> creditIds;
  List<dynamic> bankCheckIds;
  num abonos;
  String userName;
  GeneralDispenserReader generalDispenserReaderId;
  String salesControlId;

  SalesControl({
    required this.salesDate,
    required this.noDocument,
    required this.regularPrice,
    required this.superPrice,
    required this.dieselPrice,
    required this.totalGallonRegular,
    required this.totalGallonSuper,
    required this.totalGallonDiesel,
    required this.regularAccumulatedGallons,
    required this.superAccumulatedGallons,
    required this.dieselAccumulatedGallons,
    required this.total,
    required this.balance,
    required this.totalAbonosBalance,
    required this.billIds,
    required this.valeIds,
    required this.couponsIds,
    required this.voucherIds,
    required this.depositsIds,
    required this.creditIds,
    required this.bankCheckIds,
    required this.abonos,
    required this.userName,
    required this.generalDispenserReaderId,
    required this.salesControlId,
  });

  factory SalesControl.fromJson(Map<String, dynamic> json) => SalesControl(
        salesDate: DateTime.parse(json["salesDate"]),
        noDocument: json["noDocument"],
        regularPrice: json["regularPrice"],
        superPrice: json["superPrice"],
        dieselPrice: json["dieselPrice"],
        totalGallonRegular: json["totalGallonRegular"],
        totalGallonSuper: json["totalGallonSuper"],
        totalGallonDiesel: json["totalGallonDiesel"],
        regularAccumulatedGallons: json["regularAccumulatedGallons"],
        superAccumulatedGallons: json["superAccumulatedGallons"],
        dieselAccumulatedGallons: json["dieselAccumulatedGallons"],
        total: json["total"],
        balance: json["balance"],
        totalAbonosBalance: json["totalAbonosBalance"],
        billIds: List<dynamic>.from(json["billIds"].map((x) => x)),
        valeIds: List<dynamic>.from(json["valeIds"].map((x) => x)),
        couponsIds: List<dynamic>.from(json["couponsIds"].map((x) => x)),
        voucherIds: List<dynamic>.from(json["voucherIds"].map((x) => x)),
        depositsIds: List<dynamic>.from(json["depositsIds"].map((x) => x)),
        creditIds: List<dynamic>.from(json["creditIds"].map((x) => x)),
        bankCheckIds: List<dynamic>.from(json["bankCheckIds"].map((x) => x)),
        abonos: json["abonos"],
        userName: json["userName"],
        generalDispenserReaderId: GeneralDispenserReader.fromJson(
            json["generalDispenserReaderId"] ?? {}),
        salesControlId: json["salesControlId"],
      );

  Map<String, dynamic> toJson() => {
        "salesDate": salesDate.toIso8601String(),
        "noDocument": noDocument,
        "regularPrice": regularPrice,
        "superPrice": superPrice,
        "dieselPrice": dieselPrice,
        "totalGallonRegular": totalGallonRegular,
        "totalGallonSuper": totalGallonSuper,
        "totalGallonDiesel": totalGallonDiesel,
        "regularAccumulatedGallons": regularAccumulatedGallons,
        "superAccumulatedGallons": superAccumulatedGallons,
        "dieselAccumulatedGallons": dieselAccumulatedGallons,
        "total": total,
        "balance": balance,
        "totalAbonosBalance": totalAbonosBalance,
        "billIds": List<dynamic>.from(billIds.map((x) => x)),
        "valeIds": List<dynamic>.from(valeIds.map((x) => x)),
        "couponsIds": List<dynamic>.from(couponsIds.map((x) => x)),
        "voucherIds": List<dynamic>.from(voucherIds.map((x) => x)),
        "depositsIds": List<dynamic>.from(depositsIds.map((x) => x)),
        "creditIds": List<dynamic>.from(creditIds.map((x) => x)),
        "bankCheckIds": List<dynamic>.from(bankCheckIds.map((x) => x)),
        "abonos": abonos,
        "userName": userName,
        "generalDispenserReaderId": generalDispenserReaderId.toJson(),
        "salesControlId": salesControlId,
      };
}
