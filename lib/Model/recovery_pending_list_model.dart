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
      totalAmount: (json['TotalAmount'] as num?)?.toDouble() ?? 0.0,
      data: (json['Data'] as List? ?? [])
          .map((e) => RecoveryItem.fromJson(e))
          .toList(),
    );
  }
}

class RecoveryItem {
  final int id;
  final String schoolId;
  final String schoolName;
  final String schoolAddress;
  final double amount;
  final String paymentMode;
  final String receivedBy;
  final String status;
  final DateTime? date;
  final String receiptNo;
  final String voucher;
  final String mobile;
  final String remarks;

  RecoveryItem({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.schoolAddress,
    required this.amount,
    required this.paymentMode,
    required this.receivedBy,
    required this.status,
    required this.date,
    required this.receiptNo,
    required this.voucher,
    required this.mobile,
    required this.remarks,
  });

  factory RecoveryItem.fromJson(Map<String, dynamic> json) {
    return RecoveryItem(
      id: json['id'] ?? 0,
      schoolId: json['SchoolId'] ?? '',
      schoolName: json['SchoolName'] ?? '',
      schoolAddress: json['SchoolAddress'] ?? '',
      amount: (json['Amount'] as num?)?.toDouble() ?? 0.0,
      paymentMode: json['Paymentmode'] ?? '',
      receivedBy: json['RecivedByFromSchool'] ?? '',
      status: json['Status'] ?? '',
      date: json['Date'] != null
          ? DateTime.tryParse(json['Date'])
          : null,
      receiptNo: json['ReciptNo'] ?? '',
      voucher: json['Voucher'] ?? '',
      mobile: json['RecoveryAgentMobile'] ?? '',
      remarks: json['Remarks'] ?? '',
    );
  }
}