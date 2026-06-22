import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Model/AccountabtMobileResponceCashierModel.dart';
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

  Future<AccountantMobileResponse?> getAccountantMobile(
      String name) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://g17bookworld.com/api/AddDayBookApiNew/GetAccountantMobile?name=$name',
        ),
      );

      if (response.statusCode == 200) {
        return AccountantMobileResponse.fromJson(
          jsonDecode(response.body),
        );
      }

      return null;
    } catch (e) {
      debugPrint('Get Accountant Mobile Error: $e');
      return null;
    }
  }
}