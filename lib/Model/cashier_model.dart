class CashierModel {
  final String employeeId;
  final String employeeName;

  CashierModel({
    required this.employeeId,
    required this.employeeName,
  });

  factory CashierModel.fromJson(Map<String, dynamic> json) {
    return CashierModel(
      employeeId: json["Employeid"] ?? "",
      employeeName: json["EmployeeName"] ?? "",
    );
  }
}