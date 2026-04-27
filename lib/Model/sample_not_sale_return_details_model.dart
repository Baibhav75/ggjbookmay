class SampleNotSaleReturnDetailsModel {
  final Master master;
  final List<Item> items;
  final List<SeriesSummary> seriesSummary;
  final int grandTotalQty;
  final double grandTotal;
  final double finalAmount;

  SampleNotSaleReturnDetailsModel({
    required this.master,
    required this.items,
    required this.seriesSummary,
    required this.grandTotalQty,
    required this.grandTotal,
    required this.finalAmount,
  });

  factory SampleNotSaleReturnDetailsModel.fromJson(Map<String, dynamic> json) {
    return SampleNotSaleReturnDetailsModel(
      master: Master.fromJson(json['Master']),
      items: (json['Items'] as List)
          .map((e) => Item.fromJson(e))
          .toList(),
      seriesSummary: (json['SeriesSummary'] as List)
          .map((e) => SeriesSummary.fromJson(e))
          .toList(),
      grandTotalQty: json['GrandTotalQty'] ?? 0,
      grandTotal: (json['GrandTotal'] ?? 0).toDouble(),
      finalAmount: (json['FinalAmount'] ?? 0).toDouble(),
    );
  }
}

// ================= MASTER =================
class Master {
  final String billNo;
  final String schoolName;
  final String publication;
  final String address;
  final String date;

  Master({
    required this.billNo,
    required this.schoolName,
    required this.publication,
    required this.address,
    required this.date,
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      billNo: json['BillNo'] ?? '',
      schoolName: json['SchoolName'] ?? '',
      publication: json['Publication'] ?? '',
      address: json['Address'] ?? '',
      date: json['Dates'] ?? '',
    );
  }
}

// ================= ITEM =================
class Item {
  final String bookName;
  final String classes;
  final String series;
  final String publication;
  final int qty;
  final double rate;
  final double total;

  Item({
    required this.bookName,
    required this.classes,
    required this.series,
    required this.publication,
    required this.qty,
    required this.rate,
    required this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      bookName: json['BookName'] ?? '',
      classes: json['Classes'] ?? '',
      series: json['Series'] ?? '',
      publication: json['Publication'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      total: (json['TotalAmount'] ?? 0).toDouble(),
    );
  }
}

// ================= SERIES =================
class SeriesSummary {
  final String series;
  final int qty;
  final double subTotal;

  SeriesSummary({
    required this.series,
    required this.qty,
    required this.subTotal,
  });

  factory SeriesSummary.fromJson(Map<String, dynamic> json) {
    return SeriesSummary(
      series: json['Series'] ?? '',
      qty: json['Qty'] ?? 0,
      subTotal: (json['SubTotal'] ?? 0).toDouble(),
    );
  }
}