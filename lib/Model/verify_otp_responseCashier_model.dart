class VerifyOtpResponseModel {
  final bool success;

  VerifyOtpResponseModel({
    required this.success,
  });

  factory VerifyOtpResponseModel.fromJson(
      Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
    };
  }
}