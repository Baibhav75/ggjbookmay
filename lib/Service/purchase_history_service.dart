import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/purchase_history_model.dart';

class PurchaseHistoryService {

  static const String url =
      "https://g17bookworld.com/API/PurchaseHistoryList/GetPurchaseHistory";

  static Future<PurchaseHistoryModel?> fetchPurchaseHistory() async {

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);

      return PurchaseHistoryModel.fromJson(jsonData);

    } else {
      return null;
    }
  }
}