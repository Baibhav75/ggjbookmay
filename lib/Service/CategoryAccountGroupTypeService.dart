import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/CategoryAccountGroupType.dart';

class CategoryMasterService {
  static const String url =
      "https://g17bookworld.com/api/GetCategoryMasterList/GetCategoryMasterList";

  Future<CategoryMasterModel?> getCategoryMasterList() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        return CategoryMasterModel.fromJson(jsonData);
      }

      return null;
    } catch (e) {
      print("Category Master Error: $e");
      return null;
    }
  }
}