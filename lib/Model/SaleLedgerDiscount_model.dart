class SaleLedgerDiscountResponse {
  final String schoolName;
  final String address;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;
  final List<LedgerItem> ledger;

  SaleLedgerDiscountResponse({
    required this.schoolName,
    required this.address,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
    required this.ledger,
  });

  factory SaleLedgerDiscountResponse.fromJson(Map<String, dynamic> json) {
    return SaleLedgerDiscountResponse(
      schoolName: json['SchoolName'],
      address: json['Address'],
      totalDebit: (json['TotalDebit'] ?? 0).toDouble(),
      totalCredit: (json['TotalCredit'] ?? 0).toDouble(),
      closingBalance: (json['ClosingBalance'] ?? 0).toDouble(),
      ledger: (json['Ledger'] as List)
          .map((e) => LedgerItem.fromJson(e))
          .toList(),
    );
  }
}

class LedgerItem {
  final String date;
  final String type; // 👉 Vch No
  final String particulars;
  final double debit;
  final double credit;
  final double balance;

  LedgerItem({
    required this.date,
    required this.type,
    required this.particulars,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory LedgerItem.fromJson(Map<String, dynamic> json) {
    return LedgerItem(
      date: json['Date'],
      type: json['Type'], // 👈 Vch No
      particulars: json['Particulars'],
      debit: (json['Debit'] ?? 0).toDouble(),
      credit: (json['Credit'] ?? 0).toDouble(),
      balance: (json['Balance'] ?? 0).toDouble(),
    );
  }
}