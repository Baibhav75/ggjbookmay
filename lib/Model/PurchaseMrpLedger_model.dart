class PurchaseMrpLedgerModel {
  final Publication publication;
  final List<LedgerItem> data;
  final LedgerSummary summary;

  PurchaseMrpLedgerModel({
    required this.publication,
    required this.data,
    required this.summary,
  });

  factory PurchaseMrpLedgerModel.fromJson(Map<String, dynamic> json) {
    return PurchaseMrpLedgerModel(
      publication: Publication.fromJson(json['Publication'] ?? {}),
      data: (json['Data'] as List? ?? [])
          .map((e) => LedgerItem.fromJson(e))
          .toList(),
      summary: LedgerSummary.fromJson(json['Summary'] ?? {}),
    );
  }
}

// 🔹 Publication
class Publication {
  final String publicationId;
  final String publication;

  Publication({
    required this.publicationId,
    required this.publication,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      publicationId: json['PublicationId'] ?? '',
      publication: json['Publication'] ?? '',
    );
  }
}

// 🔹 Ledger Item
class LedgerItem {
  final String date;
  final String type;
  final String billNo;
  final double debit;
  final double credit;

  LedgerItem({
    required this.date,
    required this.type,
    required this.billNo,
    required this.debit,
    required this.credit,
  });

  factory LedgerItem.fromJson(Map<String, dynamic> json) {
    return LedgerItem(
      date: json['Date'] ?? '',
      type: json['Type'] ?? '',
      billNo: json['BillNo'] ?? '',
      debit: (json['Debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['Credit'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// 🔹 Summary
class LedgerSummary {
  final double totalDebit;
  final double totalCredit;
  final double balance;

  LedgerSummary({
    required this.totalDebit,
    required this.totalCredit,
    required this.balance,
  });

  factory LedgerSummary.fromJson(Map<String, dynamic> json) {
    return LedgerSummary(
      totalDebit: (json['TotalDebit'] as num?)?.toDouble() ?? 0.0,
      totalCredit: (json['TotalCredit'] as num?)?.toDouble() ?? 0.0,
      balance: (json['Balance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}