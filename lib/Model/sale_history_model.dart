class SaleHistoryModel {
  String status;
  int totalBills;
  double grandTotal;
  List<SaleHistoryData> data;

  SaleHistoryModel({
    required this.status,
    required this.totalBills,
    required this.grandTotal,
    required this.data,
  });

  factory SaleHistoryModel.fromJson(Map<String, dynamic> json) {
    return SaleHistoryModel(
      status: json['Status'],
      totalBills: json['TotalBills'],
      grandTotal: json['GrandTotal'].toDouble(),
      data: List<SaleHistoryData>.from(
        json['Data'].map((x) => SaleHistoryData.fromJson(x)),
      ),
    );
  }
}

class SaleHistoryData {
  int sNo;
  String billNo;
  String schoolName;
  String schoolId;
  String dates;
  double totalAmount;

  SaleHistoryData({
    required this.sNo,
    required this.billNo,
    required this.schoolName,
    required this.schoolId,
    required this.dates,
    required this.totalAmount,
  });

  factory SaleHistoryData.fromJson(Map<String, dynamic> json) {
    return SaleHistoryData(
      sNo: json['SNo'],
      billNo: json['BillNo'],
      schoolName: json['SchoolName'],
      schoolId: json['SchoolId'],
      dates: json['Dates'],
      totalAmount: json['TotalAmount'].toDouble(),
    );
  }
}