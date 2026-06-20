import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/sale_return_discount_ledger_model.dart';

class SaleReturnDiscountLedgerService {

  static Future<SaleReturnDiscountLedgerResponse?>
  fetchLedger(String schoolId) async {

    try {

      final response = await http.get(
        Uri.parse(
          "https://g17bookworld.com/api/LedgerSaleReturnDiscount/ViewLedgerSaleReturnDiscount?SchoolId=$schoolId",
        ),
      );

      if (response.statusCode == 200) {
        return SaleReturnDiscountLedgerResponse.fromJson(
          jsonDecode(response.body),
        );
      }

    } catch (e) {
      print(e);
    }

    return null;
  }
}