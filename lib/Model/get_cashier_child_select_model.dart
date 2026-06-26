class GetCashierChildSelectModel {
  final bool status;
  final List<GetCashierChildSelectItem> data;

  GetCashierChildSelectModel({
    required this.status,
    required this.data,
  });

  factory GetCashierChildSelectModel.fromJson(
      Map<String, dynamic> json) {
    return GetCashierChildSelectModel(
      status: json['Status'] ?? false,
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((e) => GetCashierChildSelectItem.fromJson(e))
          .toList(),
    );
  }
}

class GetCashierChildSelectItem {
  final String id;
  final String name;

  GetCashierChildSelectItem({
    required this.id,
    required this.name,
  });

  factory GetCashierChildSelectItem.fromJson(
      Map<String, dynamic> json) {
    return GetCashierChildSelectItem(
      id: json['Id']?.toString() ?? '',
      name: json['Name']?.toString() ?? '',
    );
  }
}