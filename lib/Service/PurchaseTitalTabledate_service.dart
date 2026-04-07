import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/PurchaseTitalTabledate_model.dart';

class PurchaseTitalTabledateService {

  static Future<ItemData> fetchItemDetails(String seriesId, String title) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/BookName_Class_BySeries/GetItemDetails?SeriesId=$seriesId&itemtitle=${Uri.encodeComponent(title)}"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final model = PurchaseTitalTabledateModel.fromJson(jsonData);
      return model.data;
    } else {
      throw Exception("Failed to load item details");
    }
  }
}