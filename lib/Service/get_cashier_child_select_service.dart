import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/get_cashier_child_select_model.dart';
import '../Model/get_cashier_child_select_vendor_model.dart';

class GetCashierChildSelectService {
  Future<GetCashierChildSelectModel> fetchPublications() async {
    final response = await http.get(
      Uri.parse(
        'https://g17bookworld.com/api/AddDayBookApiNew/GetPublications',
      ),
    );

    if (response.statusCode == 200) {
      return GetCashierChildSelectModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception('Failed to load publications');
  }

  Future<GetCashierChildSelectVendorModel> fetchVendors() async {
    final response = await http.get(
      Uri.parse(
        'https://g17bookworld.com/api/AddDayBookApiNew/GetVendor',
      ),
    );

    if (response.statusCode == 200) {
      return GetCashierChildSelectVendorModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception(
        'Failed to load vendors. Status Code: ${response.statusCode}',
      );
    }
  }
}
