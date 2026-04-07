import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/sale_mix_report_company_p_model.dart';

class SaleMixReportCompanyPService {
  static Future<SaleMixReportCompanyPModel> fetchReport(
      String schoolId) async {
    final url =
        "https://g17bookworld.com/api/SaleMixReportCompanyProfit/GetSaleMixReportCompanyP?schoolId=$schoolId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return SaleMixReportCompanyPModel.fromJson(
          json.decode(response.body));
    } else {
      throw Exception("API Error");
    }
  }
}