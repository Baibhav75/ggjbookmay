import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/purchase_party_entry_model.dart';

class PurchasePartyEntryService {
  static const String url =
      "https://g17bookworld.com/API/Publication/GetPublication";

  static Future<List<PurchasePartyEntryModel>> fetchPublications() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['Status'] == true) {
        List list = data['PublicationList'];

        return list
            .map((e) => PurchasePartyEntryModel.fromJson(e))
            .toList();
      }
    }

    throw Exception("Failed to load publications");
  }
}