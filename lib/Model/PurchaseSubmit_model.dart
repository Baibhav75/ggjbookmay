class PurchaseSubmitResponse {
  final String message;
  final String billNo;

  PurchaseSubmitResponse({
    required this.message,
    required this.billNo,
  });

  factory PurchaseSubmitResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseSubmitResponse(
      message: json['Message'],
      billNo: json['BillNo'],
    );
  }
}