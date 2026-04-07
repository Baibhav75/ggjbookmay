import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/publication_order_model.dart';

class PublicationOrderService {

  static Future<PublicationOrderResponse> fetchOrder(String senderId) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/publication/orderdetails?senderId=$senderId");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);

      return PublicationOrderResponse.fromJson(jsonData);

    } else {
      throw Exception("Failed to load order details");
    }
  }
}