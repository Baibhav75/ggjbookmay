import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sample_sale_billing_model.dart';

class SampleSaleBillingService {
  static const String url =
      "https://g17bookworld.com/API/SampleSaleList/GetSaleSampleList";

  static Future<SampleSaleBillingResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SampleSaleBillingResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}