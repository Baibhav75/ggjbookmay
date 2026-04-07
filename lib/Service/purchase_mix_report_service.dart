import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/PurchaseMixReport_model.dart';

class PurchaseMixReportService {

  Future<PurchaseMixReportModel?> getReport(String publicationId) async {
    final url =
        "https://g17bookworld.com/api/PurchaseMrpMixReport/GetMixReport?PublicationId=$publicationId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PurchaseMixReportModel.fromJson(jsonData);
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
    return null;
  }
}