import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/cashier_model.dart';

class CashierService {
  static Future<List<CashierModel>> getCashiers() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://g17bookworld.com/api/Cashier/cashiers",
        ),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data
            .map((e) => CashierModel.fromJson(e))
            .toList();
      }

      return [];
    } catch (e) {
      print("Cashier Error: $e");
      return [];
    }
  }
}