class CounterStockDetailsModel {
  final String billNo;
  final String schoolId;
  final String schoolName;
  final DateTime billDate;
  final double grandTotal;
  final List<CounterStockItem> items;

  CounterStockDetailsModel({
    required this.billNo,
    required this.schoolId,
    required this.schoolName,
    required this.billDate,
    required this.grandTotal,
    required this.items,
  });

  factory CounterStockDetailsModel.fromJson(Map<String, dynamic> json) {
    return CounterStockDetailsModel(
      billNo: json['BillNo'] ?? '',
      schoolId: json['SchoolId'] ?? '',
      schoolName: json['SchoolName'] ?? '',
      billDate: DateTime.tryParse(json['BillDate'] ?? '') ?? DateTime.now(),
      grandTotal: (json['GrandTotal'] as num?)?.toDouble() ?? 0.0,
      items: json['Items'] != null
          ? (json['Items'] as List)
          .map((e) => CounterStockItem.fromJson(e))
          .toList()
          : [],
    );
  }
}

class CounterStockItem {
  final String bookName;
  final String classes;
  final String subject;
  final int qty;
  final double rate;
  final double totalAmount;
  final String publication;
  final String series;

  CounterStockItem({
    required this.bookName,
    required this.classes,
    required this.subject,
    required this.qty,
    required this.rate,
    required this.totalAmount,
    required this.publication,
    required this.series,
  });

  factory CounterStockItem.fromJson(Map<String, dynamic> json) {
    return CounterStockItem(
      bookName: json['BookName'] ?? '',
      classes: json['Classes'] ?? '',
      subject: json['Subject'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['TotalAmount'] as num?)?.toDouble() ?? 0.0,
      publication: json['Publication'] ?? '',
      series: json['Series'] ?? '',
    );
  }
}