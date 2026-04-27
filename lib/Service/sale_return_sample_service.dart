import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sale_return_sample_model.dart';
import '/appDart/api_constants.dart';

class SaleReturnSampleService {

  static Future<SaleReturnSampleModel> fetchData(String billNo) async {

    final url = Uri.parse(ApiConstants.saleReturnSample(billNo));

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return SaleReturnSampleModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load invoice");
    }
  }
}