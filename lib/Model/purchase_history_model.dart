class PurchaseHistoryModel {
  final String status;
  final int totalRecords;
  final double grandTotal;
  final List<PurchaseData> data;

  PurchaseHistoryModel({
    required this.status,
    required this.totalRecords,
    required this.grandTotal,
    required this.data,
  });

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryModel(
      status: json['Status'] ?? '',
      totalRecords: json['TotalRecords'] ?? 0,
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      data: List<PurchaseData>.from(
        json['Data'].map((x) => PurchaseData.fromJson(x)),
      ),
    );
  }
}

class PurchaseData {
  final int srNo;
  final String billNo;
  final String publication;
  final String publicationId;
  final String date;
  final String groups;
  final String? grno;
  final String? box;
  final double totalAmount;

  PurchaseData({
    required this.srNo,
    required this.billNo,
    required this.publication,
    required this.publicationId,
    required this.date,
    required this.groups,
    this.grno,
    this.box,
    required this.totalAmount,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) {
    return PurchaseData(
      srNo: json['SrNo'] ?? 0,
      billNo: json['BillNo'] ?? '',
      publication: json['Publication'] ?? '',
      publicationId: json['PublicationId'] ?? '',
      date: json['Dates'] ?? '',
      groups: json['Groups'] ?? '',
      grno: json['GRNO'],
      box: json['BOX'],
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
    );
  }
}