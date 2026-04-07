class SaleDetailsMrpResponse {
  final String billNo;
  final String schoolName;
  final String billDate;
  final double grandTotal;
  final List<SaleDetailsMrpItem> items;

  SaleDetailsMrpResponse({
    required this.billNo,
    required this.schoolName,
    required this.billDate,
    required this.grandTotal,
    required this.items,
  });

  factory SaleDetailsMrpResponse.fromJson(Map<String, dynamic> json) {
    return SaleDetailsMrpResponse(
      billNo: json['BillNo']?.toString() ?? '',
      schoolName: json['SchoolName']?.toString() ?? '',
      billDate: json['BillDate']?.toString() ?? '',
      grandTotal: double.tryParse(json['GrandTotal']?.toString() ?? '0') ?? 0.0,
      items: json['Items'] != null
          ? (json['Items'] as List).map((e) => SaleDetailsMrpItem.fromJson(e)).toList()
          : [],
    );
  }
}

class SaleDetailsMrpItem {
  final String bookName;
  final String classes;
  final String subject;
  final double qty;
  final double rate;
  final double totalAmount;
  final String publication;
  final String series;

  SaleDetailsMrpItem({
    required this.bookName,
    required this.classes,
    required this.subject,
    required this.qty,
    required this.rate,
    required this.totalAmount,
    required this.publication,
    required this.series,
  });

  factory SaleDetailsMrpItem.fromJson(Map<String, dynamic> json) {
    return SaleDetailsMrpItem(
      bookName: json['BookName']?.toString() ?? '',
      classes: json['Classes']?.toString() ?? '',
      subject: json['Subject']?.toString() ?? '',
      qty: double.tryParse(json['Qty']?.toString() ?? '0') ?? 0.0,
      rate: double.tryParse(json['Rate']?.toString() ?? '0') ?? 0.0,
      totalAmount: double.tryParse(json['TotalAmount']?.toString() ?? '0') ?? 0.0,
      publication: json['Publication']?.toString() ?? '',
      series: json['Series']?.toString() ?? '',
    );
  }
}