class Bank {
  String bankName;
  String accountNumber;
  String bankId;

  Bank({
    required this.bankName,
    required this.accountNumber,
    required this.bankId,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        bankId: json["bankId"],
      );

  Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "accountNumber": accountNumber,
        "bankId": bankId,
      };
}
