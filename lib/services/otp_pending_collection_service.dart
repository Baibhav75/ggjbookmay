import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/otp_pending_collection_model.dart';

class OtpPendingCollectionService {
  static const String _baseUrl = 'https://g17bookworld.com/api/SendOtp';
  static const String _verifyUrl = 'https://g17bookworld.com/api/recovery/collect-payments';

  static Future<OtpPendingCollectionModel?> sendOtp(String mobileNumber, String schoolId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Mobile': mobileNumber,
          'SchoolId': schoolId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return OtpPendingCollectionModel.fromJson(
          data,
          mobile: mobileNumber,
          schoolId: schoolId,
        );
      } else {
        print("Failed to send OTP: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error sending OTP: $e");
      return null;
    }
  }

  static Future<({bool success, String message})> verifyOtp({
    required String ids,
    required String schoolId,
    required String otp,
    required String mobile,
    required String staffId,
    required String remarks,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_verifyUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Ids': ids,
          'SchoolId': schoolId,
          'OTP': otp,
          'Mobile': mobile,
          'StaffId': staffId,
          'Remarks': remarks,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return (
          success: data['success'] == true,
          message: data['msg']?.toString() ?? 'Payment collected successfully.',
        );
      } else {
        print("Failed to collect payment: ${response.statusCode}");
        return (
          success: false,
          message: "Failed to collect payment (Status: ${response.statusCode})",
        );
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return (
        success: false,
        message: "Error verifying OTP: $e",
      );
    }
  }
}
