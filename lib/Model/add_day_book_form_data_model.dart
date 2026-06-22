class AddDayBookFormDataModel {
  final bool status;
  final String autoVoucher;
  final String expNextBillNo;
  final List<AddDayBookLookupItem> accountGroups;
  final List<AddDayBookLookupItem> accountants;
  final List<AddDayBookLookupItem> allEmployees;
  final List<AddDayBookLookupItem> investors;
  final List<AddDayBookLookupItem> expenseParties;
  final List<AddDayBookLookupItem> expenseCategories;
  final List<AddDayBookLookupItem> schools;
  final List<AddDayBookLookupItem> customerList;

  AddDayBookFormDataModel({
    required this.status,
    required this.autoVoucher,
    required this.expNextBillNo,
    required this.accountGroups,
    required this.accountants,
    required this.allEmployees,
    required this.investors,
    required this.expenseParties,
    required this.expenseCategories,
    required this.schools,
    required this.customerList,
  });

  factory AddDayBookFormDataModel.fromJson(Map<String, dynamic> json) {
    return AddDayBookFormDataModel(
      status: json['Status'] == true,
      autoVoucher: (json['AutoVoucher'] ?? '').toString(),
      expNextBillNo: (json['ExpNextBillNo'] ?? '').toString(),
      accountGroups: AddDayBookLookupItem.listFromJson(json['AccountGroups']),
      accountants: AddDayBookLookupItem.listFromJson(json['Accountants']),
      allEmployees: AddDayBookLookupItem.listFromJson(json['AllEmployees']),
      investors: AddDayBookLookupItem.listFromJson(json['Investors']),
      expenseParties: AddDayBookLookupItem.listFromJson(json['ExpenseParties']),
      expenseCategories:
          AddDayBookLookupItem.listFromJson(json['ExpenseCategories']),
      schools: AddDayBookLookupItem.listFromJson(json['Schools']),
      customerList: AddDayBookLookupItem.listFromJson(json['CustomerList'] ?? json['Customers']),
    );
  }
}

class AddDayBookLookupItem {
  final String id;
  final String name;
  final String? mobile;

  AddDayBookLookupItem({
    required this.id,
    required this.name,
    this.mobile,
  });

  factory AddDayBookLookupItem.fromJson(Map<String, dynamic> json) {
    return AddDayBookLookupItem(
      id: (json['Id'] ?? '').toString(),
      name: (json['Name'] ?? '').toString(),
      mobile: json['Mobile']?.toString(),
    );
  }

  static List<AddDayBookLookupItem> listFromJson(dynamic value) {
    if (value is! List) {
      return <AddDayBookLookupItem>[];
    }

    return value
        .whereType<Map<String, dynamic>>()
        .map(AddDayBookLookupItem.fromJson)
        .toList();
  }
}
