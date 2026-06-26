class GetCashierChildSelectVendorModel {
  final bool status;
  final List<GetCashierChildSelectVendorItem> data;

  GetCashierChildSelectVendorModel({
    required this.status,
    required this.data,
  });

  factory GetCashierChildSelectVendorModel.fromJson(
      Map<String, dynamic> json) {
    return GetCashierChildSelectVendorModel(
      status: json['Status'] ?? false,
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((e) => GetCashierChildSelectVendorItem.fromJson(e))
          .toList(),
    );
  }
}

class GetCashierChildSelectVendorItem {
  final String id;
  final String name;

  GetCashierChildSelectVendorItem({
    required this.id,
    required this.name,
  });

  factory GetCashierChildSelectVendorItem.fromJson(
      Map<String, dynamic> json) {
    return GetCashierChildSelectVendorItem(
      id: json['Id']?.toString() ?? '',
      name: json['Name']?.toString() ?? '',
    );
  }
}