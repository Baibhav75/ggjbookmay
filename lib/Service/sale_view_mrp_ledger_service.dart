import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_view_mrp_ledger_model.dart';

class SaleViewMRPLedgerService {
  static Future<SaleViewMRPLedgerResponse?> fetchLedger(String schoolId) async {
    final url =
        "https://g17bookworld.com/api/ViewMRPLadger/GetLedger?schoolId=$schoolId";

    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return SaleViewMRPLedgerResponse.fromJson(data);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}