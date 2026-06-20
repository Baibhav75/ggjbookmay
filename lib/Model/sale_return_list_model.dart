class SaleReturnListResponse {
  final String message;
  final List<SaleReturnItem> data;
  final double grandTotal;

  SaleReturnListResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory SaleReturnListResponse.fromJson(Map<String, dynamic> json) {
    return SaleReturnListResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => SaleReturnItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class SaleReturnItem {
  final String billNo;
  final String schoolName;
  final String schoolId;
  final String date;
  final double amount;

  SaleReturnItem({
    required this.billNo,
    required this.schoolName,
    required this.schoolId,
    required this.date,
    required this.amount,
  });

  factory SaleReturnItem.fromJson(Map<String, dynamic> json) {
    return SaleReturnItem(
      billNo: json['BillNo'].toString(),
      schoolName: json['SchoolName'] ?? '',
      schoolId: json['SchoolId'] ?? '',
      date: json['Dates'] ?? '',
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}