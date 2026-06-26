class GetBankBookByIdModel {
  final bool status;
  final BankByIdData data;

  GetBankBookByIdModel({
    required this.status,
    required this.data,
  });

  factory GetBankBookByIdModel.fromJson(Map<String, dynamic> json) {
    return GetBankBookByIdModel(
      status: json["Status"] ?? false,
      data: BankByIdData.fromJson(json["Data"] ?? {}),
    );
  }
}

class BankByIdData {
  final String bankName;
  final String accountNumber;
  final String ifsc;
  final String branch;

  BankByIdData({
    required this.bankName,
    required this.accountNumber,
    required this.ifsc,
    required this.branch,
  });

  factory BankByIdData.fromJson(Map<String, dynamic> json) {
    return BankByIdData(
      bankName: json["BankName"] ?? "",
      accountNumber: json["AccountNumber"] ?? "",
      ifsc: json["IFSC"] ?? "",
      branch: json["Branch"] ?? "",
    );
  }
}