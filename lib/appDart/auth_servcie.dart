import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/view_agent_discount_details_model.dart';
import 'api_constants.dart';

class AuthService {

  static Future<ViewAgentDiscountDetailsModel?>
  getInvoiceDetails(String billNo) async {

    try {

      final response = await http.get(
        Uri.parse(
          ApiConstants.saleInvoice(billNo),
        ),
      );

      if (response.statusCode == 200) {

        return ViewAgentDiscountDetailsModel.fromJson(
          jsonDecode(response.body),
        );
      }

    } catch (e) {
      print(e);
    }

    return null;
  }
}