import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/update_order_status_model.dart';

class UpdateOrderStatusService {

  static Future<UpdateOrderStatusModel?> updateOrderStatus(
      String orderNo,
      String counterId,
      String discount,
      ) async {

    var url = Uri.parse(
        "https://g17bookworld.com/API/UpdateOrderStatus/UpdateStatus");

    try {

      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "OrderNo": orderNo,
          "CounterId": counterId,
          "Discount": discount,
        }),
      );

      print(response.body); // 👈 debug

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return UpdateOrderStatusModel.fromJson(data);
      }

    } catch (e) {
      print("Error: $e");
    }

    return null;
  }
}