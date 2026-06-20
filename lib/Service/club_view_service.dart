import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/club_view_model.dart';

class ClubViewService {
  static Future<ClubViewResponse?> fetchClubView() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://g17bookworld.com/api/salehistory/clubview',
        ),
      );

      if (response.statusCode == 200) {
        return ClubViewResponse.fromJson(
          jsonDecode(response.body),
        );
      }
    } catch (e) {
      print("Club View Error : $e");
    }

    return null;
  }
}