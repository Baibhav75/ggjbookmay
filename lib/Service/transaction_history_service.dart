import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/transaction_history_model.dart';

class TransactionHistoryService {
  static Future<TransactionHistoryResponse?> fetchTransactionHistory() async {
    try {
      final response = await http.get(
        Uri.parse('https://g17bookworld.com/api/TransactionHistoryApi/GetTransactionHistory'),
      );
      
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return TransactionHistoryResponse.fromJson(decoded);
      } else {
        print("Error fetching transactions: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in fetchTransactionHistory: $e");
    }
    return null;
  }
}
