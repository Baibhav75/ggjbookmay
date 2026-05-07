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
      data: json['Data'] != null
          ? List<PurchaseData>.from(
        json['Data'].map((x) => PurchaseData.fromJson(x)),
      )
          : [],
    );
  }
}

class PurchaseData {
  final int id;
  final int srNo; // optional (not in API but keep if needed)
  final String billNo;
  final String publication;
  final String publicationId;
  final String partyId;
  final String? party;
  final String? grno;
  final String? box;
  final double totalAmount;
  final DateTime? date;
  final DateTime? backDate;
  final String groups;
  final String? sepBillNo;

  PurchaseData({
    required this.id,
    required this.srNo,
    required this.billNo,
    required this.publication,
    required this.publicationId,
    required this.partyId,
    this.party,
    this.grno,
    this.box,
    required this.totalAmount,
    this.date,
    this.backDate,
    required this.groups,
    this.sepBillNo,
  });

  factory PurchaseData.fromJson(Map<String, dynamic> json) {
    return PurchaseData(
      id: json['id'] ?? 0,
      srNo: json['SrNo'] ?? 0,
      billNo: json['BillNo'] ?? '',
      publication: json['Publication'] ?? '',
      publicationId: json['PublicationId'] ?? '',
      partyId: json['PartyId'] ?? '',
      party: json['Party'],
      grno: json['GRNO']?.toString(),
      box: json['BOX']?.toString(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      date: json['Dates'] != null
          ? DateTime.tryParse(json['Dates'])
          : null,
      backDate: json['BackDate'] != null
          ? DateTime.tryParse(json['BackDate'])
          : null,
      groups: (json['Groups'] ?? '').toString(),
      sepBillNo: json['SepBillNo']?.toString(),
    );
  }
}