import 'package:hand_held_shell/models/enteties.exports.files.dart';
import 'package:hand_held_shell/models/models/acocounting/bank.check.model.dart';
import 'package:hand_held_shell/models/models/acocounting/credit.model.dart';
import 'package:hand_held_shell/models/models/acocounting/deposits.model.dart';
import 'package:hand_held_shell/models/models/acocounting/voucher.model.dart';

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
  List<Bill> billIds;
  List<Vale> valeIds;
  List<Coupon> couponsIds;
  List<Voucher> voucherIds;
  List<Deposit> depositsIds;
  List<Credit> creditIds;
  List<BankCheck> bankCheckIds;
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
        regularPrice: json["regularPrice"].toDouble(),
        superPrice: json["superPrice"].toDouble(),
        dieselPrice: json["dieselPrice"].toDouble(),
        totalGallonRegular: json["totalGallonRegular"].toDouble(),
        totalGallonSuper: json["totalGallonSuper"].toDouble(),
        totalGallonDiesel: json["totalGallonDiesel"].toDouble(),
        regularAccumulatedGallons: json["regularAccumulatedGallons"],
        superAccumulatedGallons: json["superAccumulatedGallons"],
        dieselAccumulatedGallons: json["dieselAccumulatedGallons"],
        total: json["total"].toDouble(),
        balance: json["balance"].toDouble(),
        totalAbonosBalance: json["totalAbonosBalance"].toDouble(),
        billIds: List<Bill>.from(json["billIds"].map((x) => Bill.fromJson(x))),
        valeIds: List<Vale>.from(json["valeIds"].map((x) => Vale.fromJson(x))),
        couponsIds: List<Coupon>.from(
            json["couponsIds"].map((x) => Coupon.fromJson(x))),
        voucherIds: List<Voucher>.from(
            json["voucherIds"].map((x) => Voucher.fromJson(x))),
        depositsIds: List<Deposit>.from(
            json["depositsIds"].map((x) => Deposit.fromJson(x))),
        creditIds:
            List<Credit>.from(json["creditIds"].map((x) => Credit.fromJson(x))),
        bankCheckIds: List<BankCheck>.from(
            json["bankCheckIds"].map((x) => BankCheck.fromJson(x))),
        abonos: json["abonos"].toDouble(),
        userName: json["userName"],
        generalDispenserReaderId:
            GeneralDispenserReader.fromJson(json["generalDispenserReaderId"]),
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
        "billIds": List<dynamic>.from(billIds.map((x) => x.toJson())),
        "valeIds": List<dynamic>.from(valeIds.map((x) => x.toJson())),
        "couponsIds": List<dynamic>.from(couponsIds.map((x) => x.toJson())),
        "voucherIds": List<dynamic>.from(voucherIds.map((x) => x.toJson())),
        "depositsIds": List<dynamic>.from(depositsIds.map((x) => x.toJson())),
        "creditIds": List<dynamic>.from(creditIds.map((x) => x.toJson())),
        "bankCheckIds": List<dynamic>.from(bankCheckIds.map((x) => x.toJson())),
        "abonos": abonos,
        "userName": userName,
        "generalDispenserReaderId": generalDispenserReaderId.toJson(),
        "salesControlId": salesControlId,
      };
}
