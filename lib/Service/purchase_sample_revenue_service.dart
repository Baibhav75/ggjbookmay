import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/purchase_sample_revenue_list_model.dart';

class PurchaseSampleRevenueService {
  static const String url =
      "https://g17bookworld.com/API/PurchaseSampleRevenueList/GetSamplePurchaseList";

  static Future<PurchaseSampleRevenueResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PurchaseSampleRevenueResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}