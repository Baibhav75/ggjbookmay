class ClubViewResponse {
  final String status;
  final int totalParties;
  final List<ClubViewItem> data;

  ClubViewResponse({
    required this.status,
    required this.totalParties,
    required this.data,
  });

  factory ClubViewResponse.fromJson(Map<String, dynamic> json) {
    return ClubViewResponse(
      status: json['Status'] ?? '',
      totalParties: json['TotalParties'] ?? 0,
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((e) => ClubViewItem.fromJson(e))
          .toList(),
    );
  }
}

class ClubViewItem {
  final int sNo;
  final String billNo;
  final String partyName;
  final String schoolId;
  final double totalAmount;

  ClubViewItem({
    required this.sNo,
    required this.billNo,
    required this.partyName,
    required this.schoolId,
    required this.totalAmount,
  });

  factory ClubViewItem.fromJson(Map<String, dynamic> json) {
    return ClubViewItem(
      sNo: json['SNo'] ?? 0,
      billNo: json['BillNo']?.toString() ?? '',
      partyName: json['PartyName'] ?? '',
      schoolId: json['SchoolId'] ?? '',
      totalAmount: double.tryParse(
        json['TotalAmount'].toString(),
      ) ??
          0,
    );
  }
}