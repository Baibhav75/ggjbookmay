class OtpPendingCollectionModel {
  final bool success;
  final String otp;
  final String response;

  OtpPendingCollectionModel({
    required this.success,
    required this.otp,
    required this.response,
  });

  factory OtpPendingCollectionModel.fromJson(Map<String, dynamic> json) {
    return OtpPendingCollectionModel(
      success: json['success'] ?? false,
      otp: json['otp']?.toString() ?? '',
      response: json['response']?.toString() ?? '',
    );
  }
}
