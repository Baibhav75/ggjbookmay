class SaleHistoryDetailsModel {
  final String status;
  final Master master;
  final double billTotalAmount;
  final List<Item> items;

  SaleHistoryDetailsModel({
    required this.status,
    required this.master,
    required this.billTotalAmount,
    required this.items,
  });

  factory SaleHistoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return SaleHistoryDetailsModel(
      status: json['Status'] ?? "",
      master: Master.fromJson(json['Master']),
      billTotalAmount: (json['BillTotalAmount'] ?? 0).toDouble(),
      items: List<Item>.from(
        (json['Items'] as List).map((x) => Item.fromJson(x)),
      ),
    );
  }
}

class Master {
  final String billNo;
  final String schoolName;
  final String schoolId;
  final String address;
  final String transport;
  final String dates;
  final String? vehicleNo;
  final String? vehicleDriverName;
  final String? vehicleDriverMoNo;

  Master({
    required this.billNo,
    required this.schoolName,
    required this.schoolId,
    required this.address,
    required this.transport,
    required this.dates,
    this.vehicleNo,
    this.vehicleDriverName,
    this.vehicleDriverMoNo,
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      billNo: json['BillNo']?.toString() ?? "",
      schoolName: json['SchoolName'] ?? "",
      schoolId: json['SchoolId'] ?? "",
      address: json['Address'] ?? "",
      transport: json['Transport'] ?? "",
      dates: json['Dates'] ?? "",
      vehicleNo: json['VehicleNo'],
      vehicleDriverName: json['VehicleDriverName'],
      vehicleDriverMoNo: json['VehicleDriverMoNo'],
    );
  }
}

class Item {
  final String bookName;
  final String? accName;
  final String publication;
  final String subject;
  final String? boardName;
  final String? seriesId;
  final String classes;
  final String series;
  final int qty;
  final double rate;
  final double totalAmount;
  final double discount;
  final double managerCommition;
  final double agentCommition;

  Item({
    required this.bookName,
    this.accName,
    required this.publication,
    required this.subject,
    this.boardName,
    this.seriesId,
    required this.classes,
    required this.series,
    required this.qty,
    required this.rate,
    required this.totalAmount,
    required this.discount,
    required this.managerCommition,
    required this.agentCommition,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      bookName: json['BookName'] ?? "",
      accName: json['AccName'],
      publication: json['Publication'] ?? "",
      subject: json['Subject'] ?? "",
      boardName: json['BoardName'],
      seriesId: json['SeriesId']?.toString(),
      classes: json['Classes'] ?? "",
      series: json['Series'] ?? "",
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      managerCommition: (json['ManagerCommition'] ?? 0).toDouble(),
      agentCommition: (json['AgentCommition'] ?? 0).toDouble(),
    );
  }
}