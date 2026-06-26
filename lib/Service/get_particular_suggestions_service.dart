import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/get_particular_suggestions_model.dart';

class GetParticularSuggestionsService {
  Future<GetParticularSuggestionsModel> getSuggestions(
      String term) async {
    final response = await http.get(
      Uri.parse(
        'https://g17bookworld.com/api/AddDayBookApiNew/GetParticularSuggestions?term=$term',
      ),
    );

    if (response.statusCode == 200) {
      return GetParticularSuggestionsModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception('Failed to load suggestions');
  }
}