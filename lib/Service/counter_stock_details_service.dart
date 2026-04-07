import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/counter_stock_details_model.dart';

class CounterStockDetailsService {

  static Future<CounterStockDetailsModel> fetchBillDetails(String billNo) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/SaleDetails/GetBillDetails?billNo=$billNo");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CounterStockDetailsModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load bill details");
    }
  }
}