import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/SaleLedgerDiscount_model.dart';

class SaleLedgerDiscountService {
  static Future<SaleLedgerDiscountResponse?> fetchLedger(String schoolId) async {
    final url =
        "https://g17bookworld.com/api/ViewLadgerSalediscount/GetLedgerDiscount?schoolId=$schoolId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return SaleLedgerDiscountResponse.fromJson(jsonData);
    } else {
      return null;
    }
  }
}