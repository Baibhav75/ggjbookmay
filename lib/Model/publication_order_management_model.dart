class PublicationOrderManagementResponse {
  final double totalPurchase;
  final double grandTotal;   // ✅ Added
  final List<PublicationOrderRecord> records;

  PublicationOrderManagementResponse({
    required this.totalPurchase,
    required this.grandTotal,
    required this.records,
  });

  factory PublicationOrderManagementResponse.fromJson(
      Map<String, dynamic> json) {
    return PublicationOrderManagementResponse(
      totalPurchase: (json['TotalPurchase'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (json['GrandTotal'] as num?)?.toDouble() ?? 0.0,
      records: (json['Records'] as List? ?? [])
          .map((e) => PublicationOrderRecord.fromJson(e))
          .toList(),
    );
  }
}

class PublicationOrderRecord {
  final String orderNo;
  final String publicationName;
  final String senderId;
  final DateTime date;
  final String publicationId;
  final String groupName;        // ✅ Added
  final double totalAmount;      // ✅ Added

  PublicationOrderRecord({
    required this.orderNo,
    required this.publicationName,
    required this.senderId,
    required this.date,
    required this.publicationId,
    required this.groupName,
    required this.totalAmount,
  });

  factory PublicationOrderRecord.fromJson(Map<String, dynamic> json) {
    return PublicationOrderRecord(
      orderNo: json['OrderNo'] ?? '',
      publicationName: json['PublicationName'] ?? '',
      senderId: json['SenderId'] ?? '',
      date: DateTime.tryParse(json['Dates'] ?? '') ?? DateTime.now(),
      publicationId: json['PublicationId'] ?? '',
      groupName: json['GroupName'] ?? '',
      totalAmount: (json['TotalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}