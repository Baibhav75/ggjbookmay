import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/recovery_pending_list_model.dart';

class RecoveryPendingService {
  static Future<RecoveryPendingListModel?> fetchData() async {
    final url = Uri.parse(
        "https://g17bookworld.com/api/RecoveryPendingList/GetPendingPayments");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return RecoveryPendingListModel.fromJson(
          json.decode(response.body));
    } else {
      return null;
    }
  }
}