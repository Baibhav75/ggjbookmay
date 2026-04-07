import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/purchase_invoice_mrp_model.dart';

class PurchaseInvoiceMrpService {

  static Future<PurchaseInvoiceMrpModel> getInvoice(String billNo) async {

    final url =
        "https://g17bookworld.com/API/PurchaseDetails/GetPurchaseInvoice?billNo=$billNo";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final jsonData = jsonDecode(response.body);

      return PurchaseInvoiceMrpModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load invoice");
    }
  }
}