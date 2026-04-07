class SaleInvoiceHistoryResponse {
  final String status;
  final int totalBills;
  final double grandTotal;
  final double totalReturn;   // ✅ NEW
  final double netSale;
  final List<SaleInvoiceHistoryItem> data;

  SaleInvoiceHistoryResponse({
    required this.status,
    required this.totalBills,
    required this.grandTotal,
    required this.totalReturn,
    required this.netSale,

    required this.data,
  });

  factory SaleInvoiceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceHistoryResponse(
      status: json['Status'] ?? '',
      totalBills: json['TotalBills'] ?? 0,
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      totalReturn: (json['TotalReturn'] ?? 0).toDouble(), // ✅ NEW
      netSale: (json['NetSale'] ?? 0).toDouble(),
      data: (json['Data'] as List)
          .map((e) => SaleInvoiceHistoryItem.fromJson(e))
          .toList(),
    );
  }
}

class SaleInvoiceHistoryItem {
  final int sNo;
  final String billNo;
  final String schoolName;
  final String schoolId;
  final String? date;
  final double totalAmount;

  SaleInvoiceHistoryItem({
    required this.sNo,
    required this.billNo,
    required this.schoolName,
    required this.schoolId,
    required this.date,
    required this.totalAmount,
  });

  factory SaleInvoiceHistoryItem.fromJson(Map<String, dynamic> json) {
    return SaleInvoiceHistoryItem(
      sNo: json['SNo'] ?? 0,
      billNo: json['BillNo'].toString(),
      schoolName: json['SchoolName'] ?? '',
      schoolId: json['SchoolId'] ?? '',
      date: json['Dates'],
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
    );
  }
}