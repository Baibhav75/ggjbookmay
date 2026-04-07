class TransferHistoryModel {
  final int id;
  final String? receiptNo;
  final String fromEmpId;
  final String fromEmpName;
  final String toEmpId;
  final String toEmpName;
  final double amount;
  final DateTime transferDate;
  final String createdBy;
  final String? remarks;
  final String? reciptImage;
  final String? payMentType;

  TransferHistoryModel({
    required this.id,
    this.receiptNo,
    required this.fromEmpId,
    required this.fromEmpName,
    required this.toEmpId,
    required this.toEmpName,
    required this.amount,
    required this.transferDate,
    required this.createdBy,
    this.remarks,
    this.reciptImage,
    this.payMentType,
  });

  factory TransferHistoryModel.fromJson(Map<String, dynamic> json) {
    return TransferHistoryModel(
      id: json['Id'] ?? 0,
      receiptNo: json['ReceiptNo'],
      fromEmpId: json['FromEmpId'] ?? '',
      fromEmpName: json['FromEmpName'] ?? '',
      toEmpId: json['ToEmpId'] ?? '',
      toEmpName: json['ToEmpName'] ?? '',
      amount: (json['Amount'] as num?)?.toDouble() ?? 0.0,
      transferDate: DateTime.parse(json['TransferDate']),
      createdBy: json['CreatedBy'] ?? '',
      remarks: json['Remarks'],
      reciptImage: json['ReciptImage'],
      payMentType: json['PayMentType'],
    );
  }
}