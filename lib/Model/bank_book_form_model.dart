class BankBookFormModel {
  final bool status;
  final BankBookData data;

  BankBookFormModel({
    required this.status,
    required this.data,
  });

  factory BankBookFormModel.fromJson(Map<String, dynamic> json) {
    return BankBookFormModel(
      status: json["Status"] ?? false,
      data: BankBookData.fromJson(json["Data"]),
    );
  }
}

class BankBookData {
  final String autoVoucher;
  final String expNextBillNo;

  final List<BankModel> banks;
  final List<PartyModel> expenseParties;
  final List<CategoryModel> expenseCategories;
  final List<LedgerGroupModel> categoryList;

  BankBookData({
    required this.autoVoucher,
    required this.expNextBillNo,
    required this.banks,
    required this.expenseParties,
    required this.expenseCategories,
    required this.categoryList,
  });

  factory BankBookData.fromJson(Map<String, dynamic> json) {
    return BankBookData(
      autoVoucher: json["AutoVoucher"] ?? "",
      expNextBillNo: json["ExpNextBillNo"] ?? "",
      banks: (json["Banks"] as List)
          .map((e) => BankModel.fromJson(e))
          .toList(),
      expenseParties: (json["ExpenseParties"] as List)
          .map((e) => PartyModel.fromJson(e))
          .toList(),
      expenseCategories: (json["ExpenseCategories"] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
      categoryList: (json["CategoryList"] as List)
          .map((e) => LedgerGroupModel.fromJson(e))
          .toList(),
    );
  }
}

class BankModel {
  final String bankId;
  final String bankName;
  final String accountNumber;

  BankModel({
    required this.bankId,
    required this.bankName,
    required this.accountNumber,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      bankId: json["BankId"] ?? "",
      bankName: json["BankName"] ?? "",
      accountNumber: json["AccountNumber"] ?? "",
    );
  }
}

class PartyModel {
  final int id;
  final String partyName;

  PartyModel({
    required this.id,
    required this.partyName,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return PartyModel(
      id: json["Id"],
      partyName: json["PartyName"] ?? "",
    );
  }
}

class CategoryModel {
  final int id;
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["Id"],
      categoryName: json["CategoryName"] ?? "",
    );
  }
}

class LedgerGroupModel {
  final String ledgerGroupId;
  final String ledgerGroup;

  LedgerGroupModel({
    required this.ledgerGroupId,
    required this.ledgerGroup,
  });

  factory LedgerGroupModel.fromJson(Map<String, dynamic> json) {
    return LedgerGroupModel(
      ledgerGroupId: json["LedgerGroupId"] ?? "",
      ledgerGroup: json["LedgerGroup"] ?? "",
    );
  }
}