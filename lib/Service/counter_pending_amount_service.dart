import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/counter_pending_amount_model.dart';

class CounterPendingAmountService {

  static Future<CounterPendingAmountModel?> getPendingAmount(String counterId) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/CounterSaleHistory/GetCounterSaleHistory?counterId=$counterId");

    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return CounterPendingAmountModel.fromJson(data);

    } else {

      throw Exception("Failed to load data");

    }
  }
}