class PurchaseDetailsDiscountInvoiceModel {
  final String billNo;
  final String publication;
  final String date;
  final int totalItems;
  final double grandTotal;
  final List<PurchaseItem> data;

  PurchaseDetailsDiscountInvoiceModel({
    required this.billNo,
    required this.publication,
    required this.date,
    required this.totalItems,
    required this.grandTotal,
    required this.data,
  });

  factory PurchaseDetailsDiscountInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PurchaseDetailsDiscountInvoiceModel(
      billNo: json['BillNo'] ?? '',
      publication: json['Publication'] ?? '',
      date: json['Date'] ?? '',
      totalItems: json['TotalItems'] ?? 0,
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      data: (json['Data'] as List)
          .map((e) => PurchaseItem.fromJson(e))
          .toList(),
    );
  }
}

class PurchaseItem {
  final String bookName;
  final String classes;
  final String subject;
  final int qty;
  final double rate;
  final double totalAmount;
  final String series;
  final double publicationDiscount;

  PurchaseItem({
    required this.bookName,
    required this.classes,
    required this.subject,
    required this.qty,
    required this.rate,
    required this.totalAmount,
    required this.series,
    required this.publicationDiscount,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      bookName: json['BookName'] ?? '',
      classes: json['Classes'] ?? '',
      subject: json['Subject'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      series: json['Series'] ?? '',
      publicationDiscount: (json['Publicationdiscount'] ?? 0).toDouble(), // ✅ SAFE HANDLE
    );
  }
}