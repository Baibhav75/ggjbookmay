import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseClubFinalDiscountLedger_model.dart';

class PurchaseClubFinalDiscountLedgerService {
  static Future<PurchaseClubFinalDiscountLedgerResponse?> fetchLedger(String partyId) async {
    try {
      final url = Uri.parse('https://g17bookworld.com/api/DiscountLedgerApi/GetDiscountLedger?PartyId=$partyId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['Status'] == true) {
          return PurchaseClubFinalDiscountLedgerResponse.fromJson(json);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching Purchase Club Final Discount Ledger: $e");
      return null;
    }
  }
}
