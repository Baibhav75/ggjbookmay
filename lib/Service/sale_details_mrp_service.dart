import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_details_mrp_model.dart';

class SaleDetailsMrpService {
  static Future<SaleDetailsMrpResponse?> fetchDetails(String billNo) async {
    final url =
        "https://g17bookworld.com/api/SaleDetails/GetBillDetails?billNo=$billNo";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SaleDetailsMrpResponse.fromJson(jsonData);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}