import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/MPIN_model.dart';
import '/appDart/api_constants.dart';

class MpinService {
  Future<MpinLoginResponse> loginWithMpin(String mpin) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.adminLogin),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "txnCode": mpin,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return MpinLoginResponse.fromJson(jsonData);
      } else {
        return MpinLoginResponse(
          success: false,
          message: "Server error: ${response.statusCode}",
        );
      }
    } catch (e) {
      return MpinLoginResponse(
        success: false,
        message: "Something went wrong",
      );
    }
  }
}