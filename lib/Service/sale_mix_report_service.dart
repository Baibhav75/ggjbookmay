import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/sale_mix_report_mrp_model.dart';

class SaleMixReportService {
  static Future<SaleMixReportMrpModel?> fetchReport(String schoolId) async {
    final url =
        "https://g17bookworld.com/api/SaleMixReportmrp/GetSaleMixReport?schoolId=$schoolId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return SaleMixReportMrpModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load report");
    }
  }
}