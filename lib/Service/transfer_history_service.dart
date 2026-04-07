import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/transfer_history_model.dart';

class TransferHistoryService {

  static Future<List<TransferHistoryModel>> fetchTransferHistory(String employeeId) async {

    final url = Uri.parse(
        "https://g17bookworld.com/API/TransferHistory/GetTransferHistory?EmployeeId=$employeeId");

    final response = await http.get(url);

    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);

      return data
          .map((e) => TransferHistoryModel.fromJson(e))
          .toList();

    } else {
      throw Exception("Failed to load transfer history");
    }
  }
}