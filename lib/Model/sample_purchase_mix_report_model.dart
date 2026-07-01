class SamplePurchaseMixReportResponse {
  final bool success;
  final String publicationName;
  final int totalQty;
  final double totalAmount;
  final double totalNetAmount;
  final List<SamplePurchaseMixReportData> data;

  SamplePurchaseMixReportResponse({
    required this.success,
    required this.publicationName,
    required this.totalQty,
    required this.totalAmount,
    required this.totalNetAmount,
    required this.data,
  });

  factory SamplePurchaseMixReportResponse.fromJson(Map<String, dynamic> json) {
    return SamplePurchaseMixReportResponse(
      success: json['Success'] ?? false,
      publicationName: json['PublicationName'] ?? '',
      totalQty: json['TotalQty'] ?? 0,
      totalAmount: (json['TotalAmount'] as num?)?.toDouble() ?? 0.0,
      totalNetAmount: (json['TotalNetAmount'] as num?)?.toDouble() ?? 0.0,
      data: (json['Data'] as List?)?.map((e) => SamplePurchaseMixReportData.fromJson(e)).toList() ?? [],
    );
  }
}

class SamplePurchaseMixReportData {
  final String publication;
  final String seriesName;
  final String bookName;
  final int qty;
  final double rate;
  final double amount;
  final double discountPercent;
  final double netAmount;

  SamplePurchaseMixReportData({
    required this.publication,
    required this.seriesName,
    required this.bookName,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.discountPercent,
    required this.netAmount,
  });

  factory SamplePurchaseMixReportData.fromJson(Map<String, dynamic> json) {
    return SamplePurchaseMixReportData(
      publication: json['Publication'] ?? '',
      seriesName: json['SeriesName'] ?? '',
      bookName: json['BookName'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] as num?)?.toDouble() ?? 0.0,
      amount: (json['Amount'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (json['DiscountPercent'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['NetAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
