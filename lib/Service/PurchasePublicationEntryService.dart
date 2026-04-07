import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/PurchasePublicationEntryModel.dart';

class PurchasePublicationEntryService {

  static Future<List<PublicationItem>> fetchPublications() async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/PublicationList/GetPublication");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final jsonData = json.decode(response.body);

      final model = PurchasePublicationEntryModel.fromJson(jsonData);

      return model.publicationList;

    } else {
      throw Exception("Failed to load publications");
    }
  }
}