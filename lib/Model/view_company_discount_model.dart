class ViewCompanyDiscountModel {
  final String billNo;
  final String publication;
  final String date;
  final int totalItems;
  final double grandTotal;
  final List<ViewCompanyItem> data;

  ViewCompanyDiscountModel({
    required this.billNo,
    required this.publication,
    required this.date,
    required this.totalItems,
    required this.grandTotal,
    required this.data,
  });

  factory ViewCompanyDiscountModel.fromJson(Map<String, dynamic> json) {
    return ViewCompanyDiscountModel(
      billNo: json['BillNo'] ?? '',
      publication: json['Publication'] ?? '',
      date: json['Date'] ?? '',
      totalItems: json['TotalItems'] ?? 0,
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      data: (json['Data'] as List)
          .map((e) => ViewCompanyItem.fromJson(e))
          .toList(),
    );
  }
}

class ViewCompanyItem {
  final String bookName;
  final String classes;
  final String subject;
  final int qty;
  final double rate;
  final double totalAmount;
  final double discount;
  final String series;

  ViewCompanyItem({
    required this.bookName,
    required this.classes,
    required this.subject,
    required this.qty,
    required this.rate,
    required this.totalAmount,
    required this.discount,
    required this.series,
  });

  factory ViewCompanyItem.fromJson(Map<String, dynamic> json) {
    return ViewCompanyItem(
      bookName: json['BookName'] ?? '',
      classes: json['Classes'] ?? '',
      subject: json['Subject'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      discount: (json['Discount'] ?? 0).toDouble(),
      series: json['Series'] ?? '',
    );
  }
}