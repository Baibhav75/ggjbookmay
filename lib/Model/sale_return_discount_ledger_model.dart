class SaleReturnDiscountLedgerResponse {
  final String status;
  final String message;

  final SchoolInfo school;
  final List<LedgerEntry> data;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;

  SaleReturnDiscountLedgerResponse({
    required this.status,
    required this.message,
    required this.school,
    required this.data,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
  });

  factory SaleReturnDiscountLedgerResponse.fromJson(
      Map<String, dynamic> json) {
    return SaleReturnDiscountLedgerResponse(
      status: json["Status"] ?? "",
      message: json["Message"] ?? "",
      school: SchoolInfo.fromJson(json["School"] ?? {}),
      data: (json["Data"] as List? ?? [])
          .map((e) => LedgerEntry.fromJson(e))
          .toList(),
      totalDebit:
      double.tryParse(json["TotalDebit"].toString()) ?? 0,
      totalCredit:
      double.tryParse(json["TotalCredit"].toString()) ?? 0,
      closingBalance:
      double.tryParse(json["ClosingBalance"].toString()) ?? 0,
    );
  }
}

class SchoolInfo {
  final String schoolId;
  final String accName;
  final String address;

  SchoolInfo({
    required this.schoolId,
    required this.accName,
    required this.address,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      schoolId: json["SchoolId"] ?? "",
      accName: json["AccName"] ?? "",
      address: json["Address"] ?? "",
    );
  }
}

class LedgerEntry {
  final String date;
  final String vchNo;
  final String type;
  final String particulars;
  final bool isOpening;
  final double? debit;
  final double? credit;
  final double balance;

  LedgerEntry({
    required this.date,
    required this.vchNo,
    required this.type,
    required this.particulars,
    required this.isOpening,
    this.debit,
    this.credit,
    required this.balance,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      date: json["Date"] ?? "",
      vchNo: json["VchNo"] ?? "",
      type: json["Type"] ?? "",
      particulars: json["Particulars"] ?? "",
      isOpening: json["IsOpening"] ?? false,
      debit: json["Debit"] == null
          ? null
          : double.tryParse(json["Debit"].toString()),
      credit: json["Credit"] == null
          ? null
          : double.tryParse(json["Credit"].toString()),
      balance:
      double.tryParse(json["Balance"].toString()) ?? 0,
    );
  }
}