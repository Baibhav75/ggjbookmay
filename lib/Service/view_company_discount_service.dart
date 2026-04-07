import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/view_company_discount_model.dart';

class ViewCompanyDiscountService {
  static Future<ViewCompanyDiscountModel> fetchInvoice(String billNo) async {
    final url =
        "https://g17bookworld.com/api/PurchaseDiscountDetails/GetPurchaseInvoice?billNo=$billNo";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ViewCompanyDiscountModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load data");
    }
  }
}