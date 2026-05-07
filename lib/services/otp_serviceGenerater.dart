import 'dart:convert';
import 'package:http/http.dart' as http;

class Fast2SmsService {
  // 🔴 Replace this with your NEW regenerated API key
  // ⚠️ Do NOT expose this in production apps
  static const String _apiKey = "Hr3E02TbWeYZqjD8z7XgAlJfotUspBSiPdNFKyn1RhOu4QLkMxrhqIAjbERxcC0oYV3MHDG4vfeBwN7J";

  static const String _baseUrl =
      "https://www.fast2sms.com/dev/bulkV2";

  /// 🔹 Send OTP
  static Future<bool> sendOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("https://www.fast2sms.com/dev/bulkV2"),
        headers: {
          "authorization": _apiKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "route": "q",
          "message": "Your OTP is $otp",
          "language": "english",
          "numbers": phone,
        }),
      );

      print("Response: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}