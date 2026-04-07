import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/counter_stock_model.dart';

class CounterStockService {

  static Future<CounterStockModel> fetchCounterStock(String counterId) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/CounterSell/GetMySchoolBills?CounterId=$counterId"
    );

    final response = await http.get(url);

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {

      final decoded = jsonDecode(response.body);

      // 🔥 IMPORTANT FIX:
      // If API returns LIST instead of object
      if (decoded is List && decoded.isNotEmpty) {
        return CounterStockModel.fromJson(decoded[0]);
      }

      if (decoded is Map<String, dynamic>) {
        return CounterStockModel.fromJson(decoded);
      }

      throw Exception("Unexpected API format");

    } else {
      throw Exception("Failed to load counter stock data");
    }
  }
}