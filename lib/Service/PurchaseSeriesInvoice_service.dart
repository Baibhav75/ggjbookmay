import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseSeriesInvoice_model.dart';

class PurchaseSeriesInvoiceService {

  static Future<List<SeriesItem>> fetchSeries(String publicationId) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/SeriesByPublication/GetSeriesByPublication?publicationId=$publicationId"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final model = PurchaseSeriesInvoiceModel.fromJson(jsonData);

      return model.data;
    } else {
      throw Exception("Failed to load series");
    }
  }
}