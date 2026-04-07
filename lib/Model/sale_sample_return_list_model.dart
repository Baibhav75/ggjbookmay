class SaleSampleReturnListResponse {
  final String message;
  final List<SaleSampleReturnItem> data;
  final double grandTotal;

  SaleSampleReturnListResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory SaleSampleReturnListResponse.fromJson(Map<String, dynamic> json) {
    return SaleSampleReturnListResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => SaleSampleReturnItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class SaleSampleReturnItem {
  final String billNo;
  final String schoolName;
  final String date;
  final String? type;
  final double amount;

  SaleSampleReturnItem({
    required this.billNo,
    required this.schoolName,
    required this.date,
    required this.type,
    required this.amount,
  });

  factory SaleSampleReturnItem.fromJson(Map<String, dynamic> json) {
    return SaleSampleReturnItem(
      billNo: json['BillNo'].toString(),
      schoolName: json['SchoolName'] ?? '',
      date: json['Dates'] ?? '',
      type: json['Type'],
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}