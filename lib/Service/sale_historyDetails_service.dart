import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Model/sale_history_details_model.dart';

class SaleHistoryDetailsService {

  static Future<SaleHistoryDetailsModel?> getInvoiceDetails(String billNo) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/SaleMrpdetails/InvoiceDetails?billNo=$billNo");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final jsonData = jsonDecode(response.body);

      return SaleHistoryDetailsModel.fromJson(jsonData);

    } else {
      return null;
    }
  }
}