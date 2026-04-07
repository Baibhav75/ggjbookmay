import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/sale_pending_mix_order_model.dart';

class SalePendingMixOrderService {
  static Future<SalePendingMixOrderModel> fetchReport(
      String schoolId) async {
    final url =
        "https://g17bookworld.com/api/Report/GetSaleMixReportOrderPending?schoolId=$schoolId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return SalePendingMixOrderModel.fromJson(
          json.decode(response.body));
    } else {
      throw Exception("API Failed");
    }
  }
}