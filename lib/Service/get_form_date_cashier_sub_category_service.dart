import 'dart:convert';

import 'package:http/http.dart' as http;

import '/Model/get_form_date_cashier_sub_category_model.dart';

class GetFormDateCashierSubCategoryService {
  static const String _baseUrl =
      'https://g17bookworld.com//api/AddDayBookApiNew/GetSubCategories';

  Future<GetFormDateCashierSubCategoryModel> fetchSubCategories(
    String categoryId,
  ) async {
    final uri = Uri.parse('$_baseUrl?categoryId=$categoryId');

    final response = await http
        .get(uri, headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load sub categories (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid sub category response');
    }

    return GetFormDateCashierSubCategoryModel.fromJson(decoded);
  }
}
