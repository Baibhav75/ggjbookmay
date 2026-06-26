class SendOtpResponseModel {
  final bool success;
  final String mobile;

  SendOtpResponseModel({
    required this.success,
    required this.mobile,
  });

  factory SendOtpResponseModel.fromJson(
      Map<String, dynamic> json) {
    return SendOtpResponseModel(
      success: json['success'] ?? false,
      mobile: json['mobile']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'mobile': mobile,
    };
  }
}