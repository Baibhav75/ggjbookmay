import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_sample_return_list_model.dart';

class SaleSampleReturnListService {
  static const String url =
      "https://g17bookworld.com/API/SampleSaleReturnList/GetSaleSampleReturnList";

  static Future<SaleSampleReturnListResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SaleSampleReturnListResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}