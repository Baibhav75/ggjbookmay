class PurchaseInvoiceMrpModel {
  final String status;
  final String billNo;
  final String publication;
  final DateTime date;
  final int totalItems;
  final double grandTotal;
  final List<PurchaseItem> data;

  PurchaseInvoiceMrpModel({
    required this.status,
    required this.billNo,
    required this.publication,
    required this.date,
    required this.totalItems,
    required this.grandTotal,
    required this.data,
  });

  factory PurchaseInvoiceMrpModel.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoiceMrpModel(
      status: json['Status'],
      billNo: json['BillNo'],
      publication: json['Publication'],
      date: DateTime.parse(json['Date']),
      totalItems: json['TotalItems'],
      grandTotal: (json['GrandTotal']).toDouble(),
      data: List<PurchaseItem>.from(
        json['Data'].map((x) => PurchaseItem.fromJson(x)),
      ),
    );
  }
}

class PurchaseItem {
  final String bookName;
  final String classes;
  final String subject;
  final int qty;
  final double rate;
  final String boardName;
  final double totalAmount;
  final String series;

  PurchaseItem({
    required this.bookName,
    required this.classes,
    required this.subject,
    required this.qty,
    required this.rate,
    required this.boardName,
    required this.totalAmount,
    required this.series,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      bookName: json['BookName'],
      classes: json['Classes'],
      subject: json['Subject'],
      qty: json['Qty'],
      rate: (json['Rate']).toDouble(),
      boardName: json['BoardName'],
      totalAmount: (json['TotalAmount']).toDouble(),
      series: json['Series'],
    );
  }
}