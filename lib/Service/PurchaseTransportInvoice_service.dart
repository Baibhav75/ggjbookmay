import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/PurchaseTransportInvoice_model.dart';

class PurchaseTransportInvoiceService {

  static Future<List<TransportItem>> fetchTransportList() async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/TransportList/GetTransportList");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);

      final model =
      PurchaseTransportInvoiceModel.fromJson(jsonData);

      return model.data;

    } else {
      throw Exception("Failed to load transport list");
    }
  }
}