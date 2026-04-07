class SaleInvoiceDetailsResponse {
  final String billNo;
  final String schoolName;
  final String address;
  final String transport;
  final String billDate;
  final String receiveDate;
  final String remark;
  final double grandAmount;
  final double grandDiscount;
  final double grandTotal;
  final List<SaleInvoiceItem> items;

  SaleInvoiceDetailsResponse({
    required this.billNo,
    required this.schoolName,
    required this.address,
    required this.transport,
    required this.billDate,
    required this.receiveDate,
    required this.remark,
    required this.grandAmount,
    required this.grandDiscount,
    required this.grandTotal,
    required this.items,
  });

  factory SaleInvoiceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceDetailsResponse(
      billNo: json['BillNo'].toString(),
      schoolName: json['SchoolName'] ?? '',
      address: json['Address'] ?? '',
      transport: json['Transport'] ?? '',
      billDate: json['BillDate'] ?? '',
      receiveDate: json['ReceiveDate'] ?? '',
      remark: json['Remark'] ?? '',
      grandAmount: (json['GrandAmount'] ?? 0).toDouble(),
      grandDiscount: (json['GrandDiscount'] ?? 0).toDouble(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      items: (json['Items'] as List)
          .map((e) => SaleInvoiceItem.fromJson(e))
          .toList(),
    );
  }
}

class SaleInvoiceItem {
  final String bookName;
  final String classes;
  final String subject;
  final double qty;
  final double rate;
  final double amount;
  final double netAmount;
  final String publication;

  SaleInvoiceItem({
    required this.bookName,
    required this.classes,
    required this.subject,
    required this.qty,
    required this.rate,
    required this.amount,
    required this.netAmount,
    required this.publication,
  });

  factory SaleInvoiceItem.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceItem(
      bookName: json['BookName'] ?? '',
      classes: json['Classes'] ?? '',
      subject: json['Subject'] ?? '',
      qty: (json['Qty'] ?? 0).toDouble(),
      rate: (json['Rate'] ?? 0).toDouble(),
      amount: (json['Amount'] ?? 0).toDouble(),
      netAmount: (json['NetAmount'] ?? 0).toDouble(),
      publication: json['Publication'] ?? '',
    );
  }
}