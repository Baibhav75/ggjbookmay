import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_invoice_details_model.dart';

class SaleInvoiceDetailsService {
  static Future<SaleInvoiceDetailsResponse?> fetchDetails(String billNo) async {
    final url =
        "https://g17bookworld.com/api/SaleDiscountDetails/GetSaleInvoice?billNo=$billNo";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SaleInvoiceDetailsResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}