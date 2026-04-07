import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseSubmit_model.dart';

class PurchaseSubmitService {

  static Future<PurchaseSubmitResponse?> submitPurchase(
      Map<String, dynamic> body) async {

    try {
      final url = Uri.parse(
          "https://g17bookworld.com/API/SavePurchaseItem/SavePurchaseEntry");

      print("📤 REQUEST BODY:");
      print(jsonEncode(body)); // 🔥 debug request

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("📥 STATUS CODE: ${response.statusCode}");
      print("📥 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return PurchaseSubmitResponse.fromJson(data);
      } else {
        print("❌ API ERROR: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ EXCEPTION: $e");
      return null;
    }
  }
}