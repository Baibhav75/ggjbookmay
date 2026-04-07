class PurchaseReturnListIndexResponse {
  final String message;
  final List<PurchaseReturnListItem> data;
  final double grandTotal;

  PurchaseReturnListIndexResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory PurchaseReturnListIndexResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnListIndexResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => PurchaseReturnListItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class PurchaseReturnListItem {
  final String billNo;
  final String publication;
  final String date;
  final double amount;

  PurchaseReturnListItem({
    required this.billNo,
    required this.publication,
    required this.date,
    required this.amount,
  });

  factory PurchaseReturnListItem.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnListItem(
      billNo: json['BillNo'].toString(),
      publication: json['Publication'] ?? '',
      date: json['Dates'] ?? '',
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}