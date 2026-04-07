class SaleSampleNotForSaleResponse {
  final String message;
  final List<SaleSampleNotForSaleItem> data;
  final double grandTotal;

  SaleSampleNotForSaleResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory SaleSampleNotForSaleResponse.fromJson(Map<String, dynamic> json) {
    return SaleSampleNotForSaleResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => SaleSampleNotForSaleItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class SaleSampleNotForSaleItem {
  final String billNo;
  final String schoolName;
  final String date;
  final double amount;

  SaleSampleNotForSaleItem({
    required this.billNo,
    required this.schoolName,
    required this.date,
    required this.amount,
  });

  factory SaleSampleNotForSaleItem.fromJson(Map<String, dynamic> json) {
    return SaleSampleNotForSaleItem(
      billNo: json['BillNo'].toString(),
      schoolName: json['SchoolName'] ?? '',
      date: json['Dates'] ?? '',
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}