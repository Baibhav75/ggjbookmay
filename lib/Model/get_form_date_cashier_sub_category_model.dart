class GetFormDateCashierSubCategoryModel {
  final bool status;
  final List<GetFormDateCashierSubCategoryItem> data;

  GetFormDateCashierSubCategoryModel({
    required this.status,
    required this.data,
  });

  factory GetFormDateCashierSubCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetFormDateCashierSubCategoryModel(
      status: json['Status'] == true,
      data: ((json['Data'] as List?) ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(GetFormDateCashierSubCategoryItem.fromJson)
          .toList(),
    );
  }
}

class GetFormDateCashierSubCategoryItem {
  final String id;
  final String subCategoryName;

  GetFormDateCashierSubCategoryItem({
    required this.id,
    required this.subCategoryName,
  });

  factory GetFormDateCashierSubCategoryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetFormDateCashierSubCategoryItem(
      id: (json['Id'] ?? '').toString(),
      subCategoryName: (json['SubCategoryName'] ?? '').toString(),
    );
  }
}
