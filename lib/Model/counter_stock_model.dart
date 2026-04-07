class CounterStockModel {
  final String counterId;
  final String counterName;
  final String schoolId;
  final String schoolName;
  final String counterBoyName;
  final String counterBoyMoNo;
  final int totalBills;
  final double grandTotalAmount;
  final List<BillModel> billList;

  CounterStockModel({
    required this.counterId,
    required this.counterName,
    required this.schoolId,
    required this.schoolName,
    required this.counterBoyName,
    required this.counterBoyMoNo,
    required this.totalBills,
    required this.grandTotalAmount,
    required this.billList,
  });

  factory CounterStockModel.fromJson(Map<String, dynamic> json) {
    return CounterStockModel(
      counterId: json['CounterId'] ?? '',
      counterName: json['CounterName'] ?? '',
      schoolId: json['SchoolId'] ?? '',
      schoolName: json['Schoolname'] ?? '',
      counterBoyName: json['CounterBoyName'] ?? '',
      counterBoyMoNo: json['CounterBoyMoNo'] ?? '',
      totalBills: json['TotalBills'] ?? 0,

      // ✅ SAFE NUMBER CONVERSION
      grandTotalAmount:
      (json['GrandTotalAmount'] as num?)?.toDouble() ?? 0.0,

      // ✅ SAFE LIST CONVERSION
      billList: json['BillList'] != null
          ? (json['BillList'] as List)
          .map((e) => BillModel.fromJson(e))
          .toList()
          : [],
    );
  }
}

class BillModel {
  final String schoolId;
  final String schoolName;
  final String billNo;
  final DateTime billDate;
  final double billAmount;

  BillModel({
    required this.schoolId,
    required this.schoolName,
    required this.billNo,
    required this.billDate,
    required this.billAmount,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      schoolId: json['SchoolId'] ?? '',
      schoolName: json['SchoolName'] ?? '',
      billNo: json['BillNo'] ?? '',

      // ✅ SAFE DATE PARSE
      billDate: json['BillDate'] != null
          ? DateTime.tryParse(json['BillDate']) ?? DateTime.now()
          : DateTime.now(),

      // ✅ SAFE NUMBER PARSE
      billAmount:
      (json['BillAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}