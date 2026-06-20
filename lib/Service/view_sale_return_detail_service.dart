import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/view_sale_return_detail_model.dart';
import '../appDart/api_constants.dart';

class ViewSaleReturnDetailService {
  static Future<ViewSaleReturnDetailResponse?> fetchDetail(
      String billNo) async {
    try {
      final response = await http.get(
        Uri.parse(
          ApiConstants.saleReturnDetail(billNo),
        ),
      );

      if (response.statusCode == 200) {
        return ViewSaleReturnDetailResponse.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (e) {
      print("Sale Return Detail Error: $e");
    }

    return null;
  }
}