import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseMrpLedger_model.dart';

class PurchaseMrpLedgerService {
  Future<PurchaseMrpLedgerModel?> getLedger(String publicationId) async {
    final url =
        "https://g17bookworld.com/api/PurchaseMrpLadger/GetPublicationLedger?PublicationId=$publicationId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return PurchaseMrpLedgerModel.fromJson(jsonData);
    } else {
      return null;
    }
  }
}