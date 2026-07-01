import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/CashierViewCashBookHistory_model.dart';

class CashierViewCashBookHistoryService {
  static const String baseUrl = 'https://g17bookworld.com';

  static Future<CashierViewCashBookHistoryResponse?> fetchCashBook() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/CashBookApi/GetCashBook'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['Status'] == true) {
          return CashierViewCashBookHistoryResponse.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching Cash Book History: \$e");
      return null;
    }
  }
}
