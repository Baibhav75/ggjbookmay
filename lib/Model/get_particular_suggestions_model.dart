class GetParticularSuggestionsModel {
  final bool status;
  final List<String> data;

  GetParticularSuggestionsModel({
    required this.status,
    required this.data,
  });

  factory GetParticularSuggestionsModel.fromJson(
      Map<String, dynamic> json) {
    return GetParticularSuggestionsModel(
      status: json['Status'] ?? false,
      data: List<String>.from(json['Data'] ?? []),
    );
  }
}