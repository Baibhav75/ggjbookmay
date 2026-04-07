import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/purchase_details_discount_invoice_model.dart';

class PurchaseDetailsDiscountInvoiceService {
  static Future<PurchaseDetailsDiscountInvoiceModel> fetchInvoice(String billNo) async {
    final url =
        "https://g17bookworld.com/api/PurchaseDetailsPublicationdiscount/GetPurchaseInvoice?billNo=$billNo";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PurchaseDetailsDiscountInvoiceModel.fromJson(
          json.decode(response.body));
    } else {
      throw Exception("Failed to load invoice");
    }
  }
}