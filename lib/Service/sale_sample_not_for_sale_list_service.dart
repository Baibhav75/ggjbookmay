import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_sample_not_for_sale_list_model.dart';

class SaleSampleNotForSaleService {
  static const String url =
      "https://g17bookworld.com/API/SaleSampleNotForSaleList/GetSaleSampleNotForSaleList";

  static Future<SaleSampleNotForSaleResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SaleSampleNotForSaleResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}