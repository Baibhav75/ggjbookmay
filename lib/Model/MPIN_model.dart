class MpinLoginResponse {
  final bool success;
  final String message;
  final AdminData? data;

  MpinLoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory MpinLoginResponse.fromJson(Map<String, dynamic> json) {
    return MpinLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AdminData.fromJson(json['data'])
          : null,
    );
  }
}

class AdminData {
  final int id;
  final String adminName;
  final String mobileNo;

  AdminData({
    required this.id,
    required this.adminName,
    required this.mobileNo,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      id: json['id'] ?? 0,
      adminName: json['AdminName'] ?? '',
      mobileNo: json['MobileNo'] ?? '',
    );
  }
}