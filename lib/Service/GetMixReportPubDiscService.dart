import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/GetMixReportPubDisc_model.dart';

class GetMixReportPubDiscService {

  static Future<GetMixReportPubDiscModel?> fetchReport(String publicationId) async {
    try {
      final url =
          "https://g17bookworld.com/api/MireportMixReportPublicationDis/GetMixReportPubDisc?PublicationId=$publicationId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response: $data");

        return GetMixReportPubDiscModel.fromJson(data);
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