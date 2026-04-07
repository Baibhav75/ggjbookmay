class VerifyTransferOtpModel {
  String? status;
  String? message;

  VerifyTransferOtpModel({this.status, this.message});

  VerifyTransferOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    return data;
  }
}
