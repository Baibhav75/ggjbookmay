import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/sample_not_sale_return_details_model.dart';
import '/appDart/api_constants.dart';

class SampleNotSaleReturnDetailsService {

  static Future<SampleNotSaleReturnDetailsModel> fetchDetails(String billNo) async {
    final url = Uri.parse(ApiConstants.sampleNotSaleReturnDetails(billNo));

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return SampleNotSaleReturnDetailsModel.fromJson(jsonData);
    } else {
      throw Exception("Failed to load data");
    }
  }
}