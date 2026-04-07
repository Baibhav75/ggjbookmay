import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseNotForSale_model.dart';

class PurchaseNotForSaleService {

  static Future<PurchaseNotForSaleResponse?> fetchList() async {
    try {
      final response = await http.get(
        Uri.parse("https://g17bookworld.com/API/PurchaseNotForSaleList/GetPurchaseNotForSaleList"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PurchaseNotForSaleResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}