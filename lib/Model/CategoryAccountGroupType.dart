class CategoryMasterModel {
  final bool status;
  final List<ParentGroup> parentGroups;
  final List<CategoryItem> categoryList;

  CategoryMasterModel({
    required this.status,
    required this.parentGroups,
    required this.categoryList,
  });

  factory CategoryMasterModel.fromJson(Map<String, dynamic> json) {
    return CategoryMasterModel(
      status: json['Status'] ?? false,
      parentGroups: (json['ParentGroups'] as List?)
          ?.map((e) => ParentGroup.fromJson(e))
          .toList() ??
          [],
      categoryList: (json['CategoryList'] as List?)
          ?.map((e) => CategoryItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class ParentGroup {
  final String id;
  final String name;

  ParentGroup({
    required this.id,
    required this.name,
  });

  factory ParentGroup.fromJson(Map<String, dynamic> json) {
    return ParentGroup(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
    );
  }
}

class CategoryItem {
  final int id;
  final dynamic ledgerGroupId;
  final String categoryName;
  final String childId;
  final String parentId;
  final String parentName;
  final bool isActive;

  CategoryItem({
    required this.id,
    this.ledgerGroupId,
    required this.categoryName,
    required this.childId,
    required this.parentId,
    required this.parentName,
    required this.isActive,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['Id'] ?? 0,
      ledgerGroupId: json['LedgerGroupId'],
      categoryName: json['CategoryName']?.toString() ?? '',
      childId: json['ChildId']?.toString() ?? '',
      parentId: json['ParentId']?.toString() ?? '',
      parentName: json['ParentName']?.toString() ?? '',
      isActive: json['IsActive'] ?? false,
    );
  }
}