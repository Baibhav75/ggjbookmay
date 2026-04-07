import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/purchase_return_not_for_sale_model.dart';

class PurchaseReturnNotForSaleService {
  static const String url =
      "https://g17bookworld.com/API/PurchaseReturnNotForSale/GetPurchaseReturnNotForSaleList";

  static Future<PurchaseReturnNotForSaleResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PurchaseReturnNotForSaleResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}