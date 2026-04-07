class SampleSaleBillingResponse {
  final String message;
  final List<SampleSaleBillingItem> data;
  final double grandTotal;

  SampleSaleBillingResponse({
    required this.message,
    required this.data,
    required this.grandTotal,
  });

  factory SampleSaleBillingResponse.fromJson(Map<String, dynamic> json) {
    return SampleSaleBillingResponse(
      message: json['Message'] ?? '',
      data: (json['Data'] as List)
          .map((e) => SampleSaleBillingItem.fromJson(e))
          .toList(),
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
    );
  }
}

class SampleSaleBillingItem {
  final String billNo;
  final String schoolName;
  final String date;
  final String? type;
  final double amount;

  SampleSaleBillingItem({
    required this.billNo,
    required this.schoolName,
    required this.date,
    required this.type,
    required this.amount,
  });

  factory SampleSaleBillingItem.fromJson(Map<String, dynamic> json) {
    return SampleSaleBillingItem(
      billNo: json['BillNo'].toString(),
      schoolName: json['SchoolName'] ?? '',
      date: json['Dates'] ?? '',
      type: json['Type'],
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}