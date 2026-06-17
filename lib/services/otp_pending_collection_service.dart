import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/otp_pending_collection_model.dart';

class OtpPendingCollectionService {
  static const String _baseUrl = 'https://g17bookworld.com//api/SendOtp';
  static const String _verifyUrl = 'https://g17bookworld.com//api/verifyOtp';

  static Future<OtpPendingCollectionModel?> sendOtp(String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobile': mobileNumber,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return OtpPendingCollectionModel.fromJson(data);
      } else {
        print("Failed to send OTP: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error sending OTP: $e");
      return null;
    }
  }

  static Future<bool> verifyOtp(String mobileNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(_verifyUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'mobile': mobileNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        print("Failed to verify OTP: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }
}
