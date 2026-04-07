class SaleMixReportCompanyPModel {
  final String schoolName;
  final List<CompanyPItem> data;
  final CompanyPSummary summary;

  SaleMixReportCompanyPModel({
    required this.schoolName,
    required this.data,
    required this.summary,
  });

  factory SaleMixReportCompanyPModel.fromJson(Map<String, dynamic> json) {
    return SaleMixReportCompanyPModel(
      schoolName: json['summary']?['SchoolName'] ?? '',
      data: (json['data'] as List)
          .map((e) => CompanyPItem.fromJson(e))
          .toList(),
      summary: CompanyPSummary.fromJson(json['summary']),
    );
  }
}

class CompanyPItem {
  final String publication;
  final String series;
  final String bookName;
  final int saleQty;
  final int returnQty;
  final int netQty;
  final double rate;
  final double amount;
  final double purchaseDiscount;
  final double saleDiscount;
  final double profitDiscount;
  final double netAmount;

  CompanyPItem({
    required this.publication,
    required this.series,
    required this.bookName,
    required this.saleQty,
    required this.returnQty,
    required this.netQty,
    required this.rate,
    required this.amount,
    required this.purchaseDiscount,
    required this.saleDiscount,
    required this.profitDiscount,
    required this.netAmount,
  });

  factory CompanyPItem.fromJson(Map<String, dynamic> json) {
    return CompanyPItem(
      publication: json['Publication'] ?? '',
      series: json['SeriesName'] ?? '',
      bookName: json['BookName'] ?? '',
      saleQty: json['SaleQty'] ?? 0,
      returnQty: json['SaleReturnQty'] ?? 0,
      netQty: json['NetQty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      amount: (json['Amount'] ?? 0).toDouble(),
      purchaseDiscount: (json['PurchaseDiscount'] ?? 0).toDouble(),
      saleDiscount: (json['SaleDiscount'] ?? 0).toDouble(),
      profitDiscount: (json['ProfitDiscount'] ?? 0).toDouble(),
      netAmount: (json['NetAmount'] ?? 0).toDouble(),
    );
  }
}

class CompanyPSummary {
  final int totalSaleQty;
  final int totalReturnQty;
  final double totalAmount;
  final double totalNetAmount;

  CompanyPSummary({
    required this.totalSaleQty,
    required this.totalReturnQty,
    required this.totalAmount,
    required this.totalNetAmount,
  });

  factory CompanyPSummary.fromJson(Map<String, dynamic> json) {
    return CompanyPSummary(
      totalSaleQty: json['TotalSaleQty'] ?? 0,
      totalReturnQty: json['TotalReturnQty'] ?? 0,
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      totalNetAmount: (json['TotalNetAmount'] ?? 0).toDouble(),
    );
  }
}