class GetChildGroupsModel {
  final bool status;
  final List<ChildGroup> data;

  GetChildGroupsModel({
    required this.status,
    required this.data,
  });

  factory GetChildGroupsModel.fromJson(Map<String, dynamic> json) {
    return GetChildGroupsModel(
      status: json["Status"] ?? false,
      data: (json["Data"] as List<dynamic>? ?? [])
          .map((e) => ChildGroup.fromJson(e))
          .toList(),
    );
  }
}

class ChildGroup {
  final String? id;
  final String name;

  ChildGroup({
    this.id,
    required this.name,
  });

  factory ChildGroup.fromJson(Map<String, dynamic> json) {
    return ChildGroup(
      id: json["Id"],
      name: json["Name"] ?? "",
    );
  }
}