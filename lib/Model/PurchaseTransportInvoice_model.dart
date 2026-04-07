class PurchaseTransportInvoiceModel {
  final String message;
  final List<TransportItem> data;

  PurchaseTransportInvoiceModel({
    required this.message,
    required this.data,
  });

  factory PurchaseTransportInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTransportInvoiceModel(
      message: json['Message'],
      data: (json['Data'] as List)
          .map((e) => TransportItem.fromJson(e))
          .toList(),
    );
  }
}

class TransportItem {
  final int id;
  final String transport;
  final String mobileNo;
  final String address;

  TransportItem({
    required this.id,
    required this.transport,
    required this.mobileNo,
    required this.address,
  });

  factory TransportItem.fromJson(Map<String, dynamic> json) {
    return TransportItem(
      id: json['id'],
      transport: json['Transport'],
      mobileNo: json['MobileNo'],
      address: json['Addresss'],
    );
  }
}