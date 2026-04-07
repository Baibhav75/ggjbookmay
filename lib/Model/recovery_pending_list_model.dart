class RecoveryPendingListModel {
  final int count;
  final double totalAmount;
  final List<RecoveryItem> data;

  RecoveryPendingListModel({
    required this.count,
    required this.totalAmount,
    required this.data,
  });

  factory RecoveryPendingListModel.fromJson(Map<String, dynamic> json) {
    return RecoveryPendingListModel(
      count: json['Count'] ?? 0,
      totalAmount: (json['TotalAmount'] as num?)?.toDouble() ?? 0,
      data: (json['Data'] as List? ?? [])
          .map((e) => RecoveryItem.fromJson(e))
          .toList(),
    );
  }
}

class RecoveryItem {
  final int id;
  final String schoolName;
  final String schoolAddress;
  final double amount;
  final String paymentMode;
  final String receivedBy;
  final String status;
  final String date;
  final String receiptNo;

  RecoveryItem({
    required this.id,
    required this.schoolName,
    required this.schoolAddress,
    required this.amount,
    required this.paymentMode,
    required this.receivedBy,
    required this.status,
    required this.date,
    required this.receiptNo,
  });

  factory RecoveryItem.fromJson(Map<String, dynamic> json) {
    return RecoveryItem(
      id: json['id'] ?? 0,
      schoolName: json['SchoolName'] ?? '',
      schoolAddress: json['SchoolAddress'] ?? '',
      amount: (json['Amount'] as num?)?.toDouble() ?? 0,
      paymentMode: json['Paymentmode'] ?? '',
      receivedBy: json['RecivedByFromSchool'] ?? '',
      status: json['Status'] ?? '',
      date: json['Date'] ?? '',
      receiptNo: json['ReciptNo'] ?? '',
    );
  }
}