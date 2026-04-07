import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/verify_transfer_otp_model.dart';

class VerifyTransferOtpService {
  Future<VerifyTransferOtpModel?> verifyTransferOtp({
    required String fromEmpId,
    required String toEmpId,
    required String amount,
    required String otp,
  }) async {
    final url = Uri.parse(
        "https://g17bookworld.com/API/VerifyOtpTransfer/VerifyTransferOTP?fromEmpId=$fromEmpId&toEmpId=$toEmpId&amount=$amount&otp=$otp");

    try {
      final response = await http.post(url);

      print("Verify OTP Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return VerifyTransferOtpModel.fromJson(jsonData);
      }
    } catch (e) {
      print("Error verifying OTP: $e");
    }

    return null;
  }
}
