import 'dart:convert';

import 'package:http/http.dart' as http;

import '/Model/add_day_book_form_data_model.dart';

class AddDayBookFormDataService {
  static const String _url =
      'https://g17bookworld.com//api/AddDayBookApiNew/GetFormData';

  Future<AddDayBookFormDataModel> fetchFormData() async {
    final response = await http
        .get(Uri.parse(_url), headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load day book form data (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid day book form response');
    }

    return AddDayBookFormDataModel.fromJson(decoded);
  }
}
