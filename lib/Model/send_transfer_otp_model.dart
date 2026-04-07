class SendTransferOtpModel {
  final String? status;
  final String? message;

  SendTransferOtpModel({
    this.status,
    this.message,
  });

  factory SendTransferOtpModel.fromJson(Map<String, dynamic> json) {
    return SendTransferOtpModel(
      status: json["Status"],
      message: json["Message"],
    );
  }
}