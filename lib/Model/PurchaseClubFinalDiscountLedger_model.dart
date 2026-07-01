class PurchaseClubFinalDiscountLedgerResponse {
  final bool status;
  final FinalDiscountData? data;

  PurchaseClubFinalDiscountLedgerResponse({
    required this.status,
    this.data,
  });

  factory PurchaseClubFinalDiscountLedgerResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseClubFinalDiscountLedgerResponse(
      status: json['Status'] ?? false,
      data: json['Data'] != null ? FinalDiscountData.fromJson(json['Data']) : null,
    );
  }
}

class FinalDiscountData {
  final FinalDiscountPublication? publication;
  final double totalDebit;
  final double totalCredit;
  final List<FinalDiscountLedgerEntry> ledger;

  FinalDiscountData({
    this.publication,
    required this.totalDebit,
    required this.totalCredit,
    required this.ledger,
  });

  factory FinalDiscountData.fromJson(Map<String, dynamic> json) {
    return FinalDiscountData(
      publication: json['Publication'] != null
          ? FinalDiscountPublication.fromJson(json['Publication'])
          : null,
      totalDebit: (json['TotalDebit'] ?? 0.0).toDouble(),
      totalCredit: (json['TotalCredit'] ?? 0.0).toDouble(),
      ledger: (json['Ledger'] as List?)
              ?.map((item) => FinalDiscountLedgerEntry.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class FinalDiscountPublication {
  final String publicationId;
  final String publicationName;
  final String gstNo;

  FinalDiscountPublication({
    required this.publicationId,
    required this.publicationName,
    required this.gstNo,
  });

  factory FinalDiscountPublication.fromJson(Map<String, dynamic> json) {
    return FinalDiscountPublication(
      publicationId: json['PublicationId'] ?? "",
      publicationName: json['Publication'] ?? "",
      gstNo: json['GstNo'] ?? "",
    );
  }
}

class FinalDiscountLedgerEntry {
  final int id;
  final String date;
  final int vchNo;
  final String type;
  final String billNo;
  final String? particulars;
  final double debit;
  final double credit;
  final String entryType;
  final double discount;
  final String? remark;

  FinalDiscountLedgerEntry({
    required this.id,
    required this.date,
    required this.vchNo,
    required this.type,
    required this.billNo,
    this.particulars,
    required this.debit,
    required this.credit,
    required this.entryType,
    required this.discount,
    this.remark,
  });

  factory FinalDiscountLedgerEntry.fromJson(Map<String, dynamic> json) {
    return FinalDiscountLedgerEntry(
      id: json['id'] ?? 0,
      date: json['Date'] ?? "",
      vchNo: json['VchNo'] ?? 0,
      type: json['Type'] ?? "",
      billNo: json['BillNo'] ?? "",
      particulars: json['Particulars'],
      debit: (json['Debit'] ?? 0.0).toDouble(),
      credit: (json['Credit'] ?? 0.0).toDouble(),
      entryType: json['EntryType'] ?? "",
      discount: (json['discount'] ?? 0.0).toDouble(),
      remark: json['Remark'],
    );
  }
}
