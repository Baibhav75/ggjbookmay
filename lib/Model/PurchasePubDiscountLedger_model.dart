class PurchasePubDiscountLedgerResponse {
  final bool success;
  final PublicationDetails? publication;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;
  final String closingBalanceType;
  final List<LedgerEntry> ledger;

  PurchasePubDiscountLedgerResponse({
    required this.success,
    this.publication,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
    required this.closingBalanceType,
    required this.ledger,
  });

  factory PurchasePubDiscountLedgerResponse.fromJson(Map<String, dynamic> json) {
    return PurchasePubDiscountLedgerResponse(
      success: json['Success'] ?? false,
      publication: json['Publication'] != null
          ? PublicationDetails.fromJson(json['Publication'])
          : null,
      totalDebit: (json['TotalDebit'] ?? 0.0).toDouble(),
      totalCredit: (json['TotalCredit'] ?? 0.0).toDouble(),
      closingBalance: (json['ClosingBalance'] ?? 0.0).toDouble(),
      closingBalanceType: json['ClosingBalanceType'] ?? "",
      ledger: (json['Ledger'] as List?)
              ?.map((item) => LedgerEntry.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class PublicationDetails {
  final String publicationId;
  final String publicationName;
  final String address;
  final String gstNo;

  PublicationDetails({
    required this.publicationId,
    required this.publicationName,
    required this.address,
    required this.gstNo,
  });

  factory PublicationDetails.fromJson(Map<String, dynamic> json) {
    return PublicationDetails(
      publicationId: json['PublicationId'] ?? "",
      publicationName: json['Publication'] ?? "",
      address: json['Address'] ?? "",
      gstNo: json['GstNo'] ?? "",
    );
  }
}

class LedgerEntry {
  final String date;
  final String type;
  final String entryType;
  final String billNo;
  final String particulars;
  final String? remark;
  final double debit;
  final double credit;
  final double balance;
  final String balanceType;

  LedgerEntry({
    required this.date,
    required this.type,
    required this.entryType,
    required this.billNo,
    required this.particulars,
    this.remark,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.balanceType,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      date: json['Date'] ?? "",
      type: json['Type'] ?? "",
      entryType: json['EntryType'] ?? "",
      billNo: json['BillNo'] ?? "",
      particulars: json['Particulars'] ?? "",
      remark: json['Remark'],
      debit: (json['Debit'] ?? 0.0).toDouble(),
      credit: (json['Credit'] ?? 0.0).toDouble(),
      balance: (json['Balance'] ?? 0.0).toDouble(),
      balanceType: json['BalanceType'] ?? "",
    );
  }
}
