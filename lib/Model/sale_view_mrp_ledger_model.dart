class SaleViewMRPLedgerResponse {
  final String schoolName;
  final String address;
  final String gstNo;

  final double totalDebit;
  final double totalCredit;
  final double closingBalance;

  final double totalSaleAmount;
  final double totalReturnAmount;
  final double totalPaymentAmount;
  final double netSale;

  final List<LedgerItem> ledger;

  SaleViewMRPLedgerResponse({
    required this.schoolName,
    required this.address,
    required this.gstNo,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
    required this.totalSaleAmount,
    required this.totalReturnAmount,
    required this.totalPaymentAmount,
    required this.netSale,
    required this.ledger,
  });

  factory SaleViewMRPLedgerResponse.fromJson(
      Map<String, dynamic> json) {
    return SaleViewMRPLedgerResponse(
      schoolName: json['SchoolName'] ?? '',
      address: json['Address'] ?? '',
      gstNo: json['Gstno'] ?? '',

      totalDebit:
      (json['TotalDebit'] as num?)?.toDouble() ?? 0,

      totalCredit:
      (json['TotalCredit'] as num?)?.toDouble() ?? 0,

      closingBalance:
      (json['ClosingBalance'] as num?)?.toDouble() ?? 0,

      totalSaleAmount:
      (json['TotalSaleAmount'] as num?)
          ?.toDouble() ??
          0,

      totalReturnAmount:
      (json['TotalReturnAmount'] as num?)
          ?.toDouble() ??
          0,

      totalPaymentAmount:
      (json['TotalPaymentAmount'] as num?)
          ?.toDouble() ??
          0,

      netSale:
      (json['NetSale'] as num?)?.toDouble() ?? 0,

      ledger: (json['Ledger'] as List?)
          ?.map(
            (e) => LedgerItem.fromJson(e),
      )
          .toList() ??
          [],
    );
  }
}

class LedgerItem {
  final String date;
  final String vchNo;
  final String type;
  final String particulars;

  final bool isOpening;

  final double debit;
  final double credit;
  final double balance;

  LedgerItem({
    required this.date,
    required this.vchNo,
    required this.type,
    required this.particulars,
    required this.isOpening,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory LedgerItem.fromJson(
      Map<String, dynamic> json) {
    return LedgerItem(
      date: json['Date'] ?? '',
      vchNo: json['VchNo'] ?? '',
      type: json['Type'] ?? '',
      particulars: json['Particulars'] ?? '',

      isOpening:
      json['IsOpening'] ?? false,

      debit:
      (json['Debit'] as num?)?.toDouble() ?? 0,

      credit:
      (json['Credit'] as num?)?.toDouble() ?? 0,

      balance:
      (json['Balance'] as num?)?.toDouble() ?? 0,
    );
  }
}