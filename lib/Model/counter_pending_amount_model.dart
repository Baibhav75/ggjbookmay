class CounterPendingAmountModel {
  final double totalPayAmount;
  final List<SaleItem> sales;

  CounterPendingAmountModel({
    required this.totalPayAmount,
    required this.sales,
  });

  factory CounterPendingAmountModel.fromJson(Map<String, dynamic> json) {
    return CounterPendingAmountModel(
      totalPayAmount: (json['TotalPayAmount'] as num?)?.toDouble() ?? 0,
      sales: (json['Sales'] as List?)
          ?.map((e) => SaleItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class SaleItem {
  final int id;
  final String orderNo;
  final String purchaserName;
  final String purchaserMobileNo;
  final String classes;
  final double totalPayAmount;
  final String paymenttype;
  final String paymentImage;
  final String counterId;
  final String counterName;
  final String schoolName;
  final String orderStatus;
  final String bookName;
  final double subjectAmount;
  final double discount;

  SaleItem({
    required this.id,
    required this.orderNo,
    required this.purchaserName,
    required this.purchaserMobileNo,
    required this.classes,
    required this.totalPayAmount,
    required this.paymenttype,
    required this.paymentImage,
    required this.counterId,
    required this.counterName,
    required this.schoolName,
    required this.orderStatus,
    required this.bookName,
    required this.subjectAmount,
    required this.discount,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: (json['Id'] as num?)?.toInt() ?? 0,
      orderNo: json['OrderNo'] ?? "",
      purchaserName: json['PurchaserName'] ?? "",
      purchaserMobileNo: json['PurchaserMobileNo'] ?? "",
      classes: json['Classes'] ?? "",
      totalPayAmount: (json['TotalPayAmount'] as num?)?.toDouble() ?? 0,
      paymenttype: json['Paymenttype'] ?? "",
      paymentImage: json['PaymentImage'] ?? "",
      counterId: json['CounterId'] ?? "",
      counterName: json['CounterName'] ?? "",
      schoolName: json['SchoolName'] ?? "",
      orderStatus: json['OrderStatus'] ?? "",
      bookName: json['bookName'] ?? "",
      subjectAmount: (json['SubjectAmount'] as num?)?.toDouble() ?? 0,
      discount: (json['Discount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}