class PurchaseTitalInvoiceModel {
  final String message;
  final List<String> data;

  PurchaseTitalInvoiceModel({
    required this.message,
    required this.data,
  });

  factory PurchaseTitalInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTitalInvoiceModel(
      message: json['Message'],
      data: List<String>.from(json['Data']),
    );
  }
}