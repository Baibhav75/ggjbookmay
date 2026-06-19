class OtpPendingCollectionModel {
  final bool success;
  final String otp;
  final String response;
  final String? mobile;
  final String? schoolId;

  OtpPendingCollectionModel({
    required this.success,
    required this.otp,
    required this.response,
    this.mobile,
    this.schoolId,
  });

  factory OtpPendingCollectionModel.fromJson(Map<String, dynamic> json, {String? mobile, String? schoolId}) {
    return OtpPendingCollectionModel(
      success: json['success'] ?? false,
      otp: json['otp']?.toString() ?? '',
      response: json['response']?.toString() ?? '',
      mobile: mobile,
      schoolId: schoolId,
    );
  }
}
