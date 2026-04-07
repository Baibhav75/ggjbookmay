import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_invoice_history_model.dart';

class SaleInvoiceHistoryService {
  static const String url =
      "https://g17bookworld.com/API/salehistory/list";

  static Future<SaleInvoiceHistoryResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SaleInvoiceHistoryResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}