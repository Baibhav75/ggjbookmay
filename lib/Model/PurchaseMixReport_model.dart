class PurchaseMixReportModel {
  final String status;
  final String publication;
  final PurchaseSummary summary;
  final List<PurchaseItem> data;

  PurchaseMixReportModel({
    required this.status,
    required this.publication,
    required this.summary,
    required this.data,
  });

  factory PurchaseMixReportModel.fromJson(Map<String, dynamic> json) {
    return PurchaseMixReportModel(
      status: json['Status'] ?? '',
      publication: json['Publication'] ?? '',
      summary: PurchaseSummary.fromJson(json['Summary'] ?? {}),
      data: (json['Data'] as List? ?? [])
          .map((e) => PurchaseItem.fromJson(e))
          .toList(),
    );
  }
}

// 🔹 Summary Model
class PurchaseSummary {
  final int totalPurchaseQty;
  final int totalReturnQty;
  final double totalAmount;
  final double totalNetAmount;
  final double totalPaidAmount;
  final double grossProfit;
  final double closingAmount;

  PurchaseSummary({
    required this.totalPurchaseQty,
    required this.totalReturnQty,
    required this.totalAmount,
    required this.totalNetAmount,
    required this.totalPaidAmount,
    required this.grossProfit,
    required this.closingAmount,
  });

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseSummary(
      totalPurchaseQty: json['TotalPurchaseQty'] ?? 0,
      totalReturnQty: json['TotalReturnQty'] ?? 0,
      totalAmount: (json['TotalAmount'] as num?)?.toDouble() ?? 0.0,
      totalNetAmount: (json['TotalNetAmount'] as num?)?.toDouble() ?? 0.0,
      totalPaidAmount: (json['TotalPaidAmount'] as num?)?.toDouble() ?? 0.0,
      grossProfit: (json['GrossProfit'] as num?)?.toDouble() ?? 0.0,
      closingAmount: (json['ClosingAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// 🔹 Item Model
class PurchaseItem {
  final String publicationName;
  final String seriesName;
  final String bookName;
  final int purchaseQty;
  final int returnQty;
  final int netQty;
  final double rate;
  final double amount;
  final double netAmount;

  PurchaseItem({
    required this.publicationName,
    required this.seriesName,
    required this.bookName,
    required this.purchaseQty,
    required this.returnQty,
    required this.netQty,
    required this.rate,
    required this.amount,
    required this.netAmount,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      publicationName: json['PublicationName'] ?? '',
      seriesName: json['SeriesName'] ?? '',
      bookName: json['BookName'] ?? '',
      purchaseQty: json['PurchaseQty'] ?? 0,
      returnQty: json['ReturnQty'] ?? 0,
      netQty: json['NetQty'] ?? 0,
      rate: (json['Rate'] as num?)?.toDouble() ?? 0.0,
      amount: (json['Amount'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['NetAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}