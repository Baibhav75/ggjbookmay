class GetBankBookBalanceModel {
  final bool status;
  final double balance;

  GetBankBookBalanceModel({
    required this.status,
    required this.balance,
  });

  factory GetBankBookBalanceModel.fromJson(Map<String, dynamic> json) {
    return GetBankBookBalanceModel(
      status: json["Status"] ?? false,
      balance: (json["balance"] ?? 0).toDouble(),
    );
  }
}