import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/purchase_sample_revenue_return_model.dart';

class PurchaseSampleRevenueReturnService {
  static const String url =
      "https://g17bookworld.com/API/PurchaseSampleRevenueReturnList/GetSamplePurchaseList";

  static Future<PurchaseSampleRevenueReturnResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PurchaseSampleRevenueReturnResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}