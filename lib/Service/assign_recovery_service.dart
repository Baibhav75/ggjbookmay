import 'dart:convert';
import 'package:http/http.dart' as http;

class AssignRecoveryService {
  static const String url =
      'https://g17bookworld.com/api/RecoveryAssign/AssignRecovery';

  static Future<Map<String, dynamic>?> assignRecovery({
    required String schoolId,
    required String employeeId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "SchoolId": schoolId,
          "EmployeeId": employeeId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Assign Response: $data");
        return data;
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}