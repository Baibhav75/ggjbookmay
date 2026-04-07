import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/purchase_return_list_index_model.dart';

class PurchaseReturnListIndexService {
  static const String url =
      "https://g17bookworld.com/API/PurchaseReturnlist/GetPurchaseReturn";

  static Future<PurchaseReturnListIndexResponse?> fetchList() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PurchaseReturnListIndexResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}