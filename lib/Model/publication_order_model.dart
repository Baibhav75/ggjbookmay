class PublicationOrderResponse {
  final bool status;
  final OrderDetails orderDetails;
  final List<String> schools;
  final List<OrderItem> items;

  PublicationOrderResponse({
    required this.status,
    required this.orderDetails,
    required this.schools,
    required this.items,
  });

  factory PublicationOrderResponse.fromJson(Map<String, dynamic> json) {
    return PublicationOrderResponse(
      status: json['Status'],
      orderDetails: OrderDetails.fromJson(json['OrderDetails']),
      schools: List<String>.from(json['Schools'] ?? []),
      items: (json['Items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}

class OrderDetails {
  final String senderId;
  final String orderNo;
  final String supplier;
  final String billDate;
  final String bookingFrom;
  final String address;

  OrderDetails({
    required this.senderId,
    required this.orderNo,
    required this.supplier,
    required this.billDate,
    required this.bookingFrom,
    required this.address,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      senderId: json['SenderId'] ?? '',
      orderNo: json['OrderNo'] ?? '',
      supplier: json['Supplier'] ?? '',
      billDate: json['BillDate'] ?? '',
      bookingFrom: json['BookingFrom'] ?? '',
      address: json['Address'] ?? '',
    );
  }
}

class OrderItem {
  final String bookName;
  final String subject;
  final String classes;
  final String series;
  final int qty;
  final double rate;
  final double totalAmount;

  OrderItem({
    required this.bookName,
    required this.subject,
    required this.classes,
    required this.series,
    required this.qty,
    required this.rate,
    required this.totalAmount,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      bookName: json['BookName'] ?? '',
      subject: json['Subject'] ?? '',
      classes: json['Classes'] ?? '',
      series: json['Series'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] as num).toDouble(),
      totalAmount: (json['TotalAmount'] as num).toDouble(),
    );
  }
}