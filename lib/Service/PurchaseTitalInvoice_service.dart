import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseTitalInvoice_model.dart';

class PurchaseTitalInvoiceService {

  static Future<List<String>> fetchTitles(String seriesId) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/BookNameBySeries/GetTitlesBySeries?SeriesId=$seriesId"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final model = PurchaseTitalInvoiceModel.fromJson(jsonData);

      return model.data;
    } else {
      throw Exception("Failed to load titles");
    }
  }
}