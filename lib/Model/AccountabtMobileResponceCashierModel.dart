class AccountantMobileResponse {
  final String mobile;

  AccountantMobileResponse({
    required this.mobile,
  });

  factory AccountantMobileResponse.fromJson(
      Map<String, dynamic> json) {
    return AccountantMobileResponse(
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobile': mobile,
    };
  }
}