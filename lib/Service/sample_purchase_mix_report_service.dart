import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sample_purchase_mix_report_model.dart';

class SamplePurchaseMixReportService {
  static Future<SamplePurchaseMixReportResponse?> fetchReport(String publicationId) async {
    try {
      final url = Uri.parse('https://g17bookworld.com/api/samplepurchase/mixreport?publicationId=$publicationId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['Success'] == true) {
          return SamplePurchaseMixReportResponse.fromJson(json);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching Sample Purchase Mix Report: $e");
      return null;
    }
  }
}
