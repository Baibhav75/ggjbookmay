class AddLadgerKhataResponse {
  final bool status;
  final String message;
  final String? receiptNo;

  AddLadgerKhataResponse({
    required this.status,
    required this.message,
    this.receiptNo,
  });

  factory AddLadgerKhataResponse.fromJson(Map<String, dynamic> json) {
    return AddLadgerKhataResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      receiptNo: json['ReceiptNo']?.toString(),
    );
  }
}
