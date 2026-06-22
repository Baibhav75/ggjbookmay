import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/add_ladger_khata_response_model.dart';

class AddLadgerKhataService {
  Future<AddLadgerKhataResponse> submitSchoolPayment({
    required String schoolId,
    required String cashierId,
    required String agentId,
    required String paymentDate,
    required String amount,
    required String remarks,
    required String customerMobile,
  }) async {
    final url = Uri.parse('https://g17bookworld.com/api/AddDayBookApiNew/AddLadgerKhataPost');

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'FormSection': 'SCHOOLPAYMENT',
      'SchoolPaySchoolId': schoolId,
      'SchoolPayCashierId': cashierId,
      'SchoolPayAgentId': agentId,
      'SchoolPayPaymentDate': paymentDate,
      'SchoolPayAmount': amount,
      'SchoolPayRemarks': remarks,
      'SchoolPayCustomerMobile': customerMobile,
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return AddLadgerKhataResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to submit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
