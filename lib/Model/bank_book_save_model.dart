class BankBookSaveModel {
  final bool status;
  final String message;

  BankBookSaveModel({
    required this.status,
    required this.message,
  });

  factory BankBookSaveModel.fromJson(Map<String, dynamic> json) {
    return BankBookSaveModel(
      status: json["Status"] ?? false,
      message: json["Message"] ?? "",
    );
  }
}