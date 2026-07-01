import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_sample_not_for_sale_invoice_model.dart';

class SaleSampleNotForSaleInvoiceService {
  static Future<SaleSampleNotForSaleInvoiceResponse?> fetchInvoice(String billNo) async {
    try {
      final url = Uri.parse('https://g17bookworld.com/api/SaleSampleNotForSale/ViewSaleSampleNotForSaleInvoice?billNo=$billNo');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['Status'] == 'Success' && json['Invoice'] != null) {
          return SaleSampleNotForSaleInvoiceResponse.fromJson(json);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching Sale Sample Not For Sale Invoice: $e");
      return null;
    }
  }
}
