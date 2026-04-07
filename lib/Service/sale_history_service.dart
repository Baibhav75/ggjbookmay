import 'dart:convert';
import 'package:http/http.dart' as http;

import '/Model/sale_history_model.dart';

class SaleHistoryService {

  static const String url =
      "https://g17bookworld.com/API/salehistory/list";

  static Future<List<SaleHistoryData>> fetchSaleHistory() async {

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final jsonData = jsonDecode(response.body);

      SaleHistoryModel model = SaleHistoryModel.fromJson(jsonData);

      return model.data;

    } else {
      throw Exception("Failed to load Sale History");
    }
  }
}