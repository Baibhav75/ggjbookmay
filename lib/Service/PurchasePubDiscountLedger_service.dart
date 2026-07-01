import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchasePubDiscountLedger_model.dart';

class PurchasePubDiscountLedgerService {
  static Future<PurchasePubDiscountLedgerResponse?> fetchLedger(String partyId) async {
    try {
      final url = Uri.parse('https://g17bookworld.com/api/publication/discountledger?partyId=$partyId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['Success'] == true) {
          return PurchasePubDiscountLedgerResponse.fromJson(json);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching Purchase Pub Discount Ledger: $e");
      return null;
    }
  }
}
