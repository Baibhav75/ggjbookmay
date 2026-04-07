class PurchaseReturnNotForSaleResponse {
  final String message;
  final List<PurchaseReturnItem> data;
  final double grandTotal;

  PurchaseReturnNotForSaleResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory PurchaseReturnNotForSaleResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnNotForSaleResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => PurchaseReturnItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class PurchaseReturnItem {
  final String billNo;
  final String publication;
  final String date;
  final double amount;

  PurchaseReturnItem({
    required this.billNo,
    required this.publication,
    required this.date,
    required this.amount,
  });

  factory PurchaseReturnItem.fromJson(Map<String, dynamic> json) {
    return PurchaseReturnItem(
      billNo: json['BillNo'].toString(),
      publication: json['Publication'] ?? '',
      date: json['Dates'] ?? '',
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}