import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_return_list_model.dart';

class SaleReturnListService {
  static const String url =
      "https://g17bookworld.com/API/SaleReturnList/GetSaleReturnList";

  static Future<SaleReturnListResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SaleReturnListResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}