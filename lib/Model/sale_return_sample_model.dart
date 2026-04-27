class SaleReturnSampleModel {
  final Master master;
  final List<Item> items;
  final List<SeriesSummary> seriesSummary;
  final int grandQty;
  final double grandTotal;
  final double finalAmount;

  SaleReturnSampleModel({
    required this.master,
    required this.items,
    required this.seriesSummary,
    required this.grandQty,
    required this.grandTotal,
    required this.finalAmount,
  });

  factory SaleReturnSampleModel.fromJson(Map<String, dynamic> json) {
    return SaleReturnSampleModel(
      master: Master.fromJson(json['Master']),
      items: (json['Items'] as List)
          .map((e) => Item.fromJson(e))
          .toList(),
      seriesSummary: (json['SeriesSummary'] as List)
          .map((e) => SeriesSummary.fromJson(e))
          .toList(),
      grandQty: json['GrandQty'] ?? 0,
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      finalAmount: (json['FinalAmount'] ?? 0).toDouble(),
    );
  }
}

/// 🔴 MASTER
class Master {
  final String billNo;
  final String schoolName;
  final String publication;
  final String date;
  final String address;
  final String transport;
  final String remark;

  Master({
    required this.billNo,
    required this.schoolName,
    required this.publication,
    required this.date,
    this.address = '',
    this.transport = '',
    this.remark = '',
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      billNo: json['BillNo'] ?? '',
      schoolName: json['SchoolName'] ?? '',
      publication: json['Publication'] ?? '',
      date: json['Dates'] ?? '',
      address: json['Address'] ?? '',
      transport: json['Transport'] ?? '',
      remark: json['Remarks'] ?? '',
    );
  }
}

/// 📦 ITEM
class Item {
  final String bookName;
  final String classes;
  final int qty;
  final double rate;
  final double total;
  final String series;

  Item({
    required this.bookName,
    required this.classes,
    required this.qty,
    required this.rate,
    required this.total,
    required this.series,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      bookName: json['BookName'] ?? '',
      classes: json['Classes'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      total: (json['TotalAmount'] ?? 0).toDouble(),
      series: json['Series'] ?? '',
    );
  }
}

/// 📊 SERIES SUMMARY
class SeriesSummary {
  final String series;
  final int qty;
  final double total;

  SeriesSummary({
    required this.series,
    required this.qty,
    required this.total,
  });

  factory SeriesSummary.fromJson(Map<String, dynamic> json) {
    return SeriesSummary(
      series: json['Series'] ?? '',
      qty: json['Qty'] ?? 0,
      total: (json['Total'] ?? 0).toDouble(),
    );
  }
}