class SaleMixReportMrpModel {
  final String schoolName;
  final int totalSaleQty;
  final int totalReturnQty;
  final double totalAmount;
  final double totalNetAmount;
  final List<SaleMixItem> data;

  SaleMixReportMrpModel({
    required this.schoolName,
    required this.totalSaleQty,
    required this.totalReturnQty,
    required this.totalAmount,
    required this.totalNetAmount,
    required this.data,
  });

  factory SaleMixReportMrpModel.fromJson(Map<String, dynamic> json) {
    return SaleMixReportMrpModel(
      schoolName: json['SchoolName'] ?? '',
      totalSaleQty: json['TotalSaleQty'] ?? 0,
      totalReturnQty: json['TotalReturnQty'] ?? 0,
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      totalNetAmount: (json['TotalNetAmount'] ?? 0).toDouble(),
      data: (json['Data'] as List)
          .map((e) => SaleMixItem.fromJson(e))
          .toList(),
    );
  }
}

class SaleMixItem {
  final String publication;
  final String series;
  final String bookName;
  final int saleQty;
  final int returnQty;
  final int netQty;
  final double rate;
  final double amount;
  final double discount;
  final double netAmount;

  SaleMixItem({
    required this.publication,
    required this.series,
    required this.bookName,
    required this.saleQty,
    required this.returnQty,
    required this.netQty,
    required this.rate,
    required this.amount,
    required this.discount,
    required this.netAmount,
  });

  factory SaleMixItem.fromJson(Map<String, dynamic> json) {
    return SaleMixItem(
      publication: json['Publication'] ?? '',
      series: json['Series'] ?? '',
      bookName: json['BookName'] ?? '',
      saleQty: json['SaleQty'] ?? 0,
      returnQty: json['SaleReturnQty'] ?? 0,
      netQty: json['NetQty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      amount: (json['Amount'] ?? 0).toDouble(),
      discount: (json['DiscountPercent'] ?? 0).toDouble(),
      netAmount: (json['NetAmount'] ?? 0).toDouble(),
    );
  }
}