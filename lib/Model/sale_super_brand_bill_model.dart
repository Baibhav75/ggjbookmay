class SaleSuperBrandBillDetailsModel {
  final String status;
  final Master master;
  final double billTotalAmount;
  final List<Item> items;

  SaleSuperBrandBillDetailsModel({
    required this.status,
    required this.master,
    required this.billTotalAmount,
    required this.items,
  });

  factory SaleSuperBrandBillDetailsModel.fromJson(Map<String, dynamic> json) {
    return SaleSuperBrandBillDetailsModel(
      status: json['Status'],
      master: Master.fromJson(json['Master']),
      billTotalAmount: (json['BillTotalAmount'] ?? 0).toDouble(),
      items: (json['Items'] as List)
          .map((e) => Item.fromJson(e))
          .toList(),
    );
  }
}

class Master {
  final String billNo;
  final String schoolName;
  final String? address;
  final String? transport;
  final String dates;

  Master({
    required this.billNo,
    required this.schoolName,
    this.address,
    this.transport,
    required this.dates,
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      billNo: json['BillNo'] ?? "",
      schoolName: json['SchoolName'] ?? "",
      address: json['Address'],
      transport: json['Transport'],
      dates: json['Dates'] ?? "",
    );
  }
}

class Item {
  final String bookName;
  final String publication;
  final String subject;
  final String classes;
  final String series;
  final int qty;
  final double rate;
  final double totalAmount;

  Item({
    required this.bookName,
    required this.publication,
    required this.subject,
    required this.classes,
    required this.series,
    required this.qty,
    required this.rate,
    required this.totalAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      bookName: json['BookName'] ?? "",
      publication: json['Publication'] ?? "",
      subject: json['Subject'] ?? "",
      classes: json['Classes'] ?? "",
      series: json['Series'] ?? "",
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
    );
  }
}