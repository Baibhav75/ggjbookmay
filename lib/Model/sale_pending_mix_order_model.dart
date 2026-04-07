class SalePendingMixOrderModel {
  final String schoolName;
  final List<SalePendingItem> data;
  final Summary summary;

  SalePendingMixOrderModel({
    required this.schoolName,
    required this.data,
    required this.summary,
  });

  factory SalePendingMixOrderModel.fromJson(Map<String, dynamic> json) {
    return SalePendingMixOrderModel(
      schoolName: json['SchoolName'] ?? '',
      data: (json['Data'] as List)
          .map((e) => SalePendingItem.fromJson(e))
          .toList(),
      summary: Summary.fromJson(json['Summary']),
    );
  }
}

class SalePendingItem {
  final String publication;
  final String series;
  final String bookName;
  final int totalOrder;
  final int sale;
  final String pending;
  final double rate;

  SalePendingItem({
    required this.publication,
    required this.series,
    required this.bookName,
    required this.totalOrder,
    required this.sale,
    required this.pending,
    required this.rate,
  });

  factory SalePendingItem.fromJson(Map<String, dynamic> json) {
    return SalePendingItem(
      publication: json['Publication'] ?? '',
      series: json['Series'] ?? '',
      bookName: json['BookName'] ?? '',
      totalOrder: json['TotalOrder'] ?? 0,
      sale: json['Sale'] ?? 0,
      pending: json['Pending'] ?? '',
      rate: (json['Rate'] ?? 0).toDouble(),
    );
  }
}

class Summary {
  final int totalOrder;
  final int totalSale;
  final double totalRate;
  final int totalPending;

  Summary({
    required this.totalOrder,
    required this.totalSale,
    required this.totalRate,
    required this.totalPending,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalOrder: json['TotalOrder'] ?? 0,
      totalSale: json['TotalSale'] ?? 0,
      totalRate: (json['TotalRate'] ?? 0).toDouble(),
      totalPending: json['TotalPending'] ?? 0,
    );
  }
}