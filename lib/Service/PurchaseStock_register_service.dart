import 'dart:convert';
import 'package:http/http.dart' as http;

import '/Model/Purchasestock_register_model.dart';
import '/appDart/api_constants.dart';

class StockRegisterService {
  Future<StockRegisterModel?> fetchStock(String publicationId) async {
    final url =
        "${ApiConstants.baseUrl}${ApiConstants.stockRegister}?PublicationId=$publicationId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return StockRegisterModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load stock register");
    }
  }
}