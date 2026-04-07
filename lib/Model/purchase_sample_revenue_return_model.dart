class PurchaseSampleRevenueReturnResponse {
  final String message;
  final List<PurchaseSampleRevenueReturnItem> data;
  final double grandTotal;

  PurchaseSampleRevenueReturnResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory PurchaseSampleRevenueReturnResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseSampleRevenueReturnResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => PurchaseSampleRevenueReturnItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class PurchaseSampleRevenueReturnItem {
  final String billNo;
  final String publication;
  final String date;
  final double amount;

  PurchaseSampleRevenueReturnItem({
    required this.billNo,
    required this.publication,
    required this.date,
    required this.amount,
  });

  factory PurchaseSampleRevenueReturnItem.fromJson(Map<String, dynamic> json) {
    return PurchaseSampleRevenueReturnItem(
      billNo: json['BillNo'].toString(),
      publication: json['Publication'] ?? '',
      date: json['Dates'] ?? '',
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}