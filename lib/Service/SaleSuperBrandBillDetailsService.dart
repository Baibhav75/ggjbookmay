import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/sale_super_brand_bill_model.dart';
import '/appDart/api_constants.dart';

class SaleSuperBrandBillService {
  Future<SaleSuperBrandBillDetailsModel?> fetchBill(String billNo) async {
    final url =
        "${ApiConstants.baseUrl}${ApiConstants.saleSuperBrandBillDetails}?billNo=$billNo";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return SaleSuperBrandBillDetailsModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load bill details");
    }
  }
}