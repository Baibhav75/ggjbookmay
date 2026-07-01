class CashierViewCashBookHistoryResponse {
  final bool status;
  final List<CashBookDayData> data;

  CashierViewCashBookHistoryResponse({
    required this.status,
    required this.data,
  });

  factory CashierViewCashBookHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CashierViewCashBookHistoryResponse(
      status: json['Status'] ?? false,
      data: (json['Data'] as List?)
              ?.map((item) => CashBookDayData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CashBookDayData {
  final String date;
  final List<CashBookTransaction> transactions;
  final double totalDebit;
  final double totalCredit;
  final double finalBalance;
  final double? totalOpening;
  final double openingBalance;
  final double todayOpeningBalance;
  final double nextDayFinalBalance;

  CashBookDayData({
    required this.date,
    required this.transactions,
    required this.totalDebit,
    required this.totalCredit,
    required this.finalBalance,
    this.totalOpening,
    required this.openingBalance,
    required this.todayOpeningBalance,
    required this.nextDayFinalBalance,
  });

  factory CashBookDayData.fromJson(Map<String, dynamic> json) {
    return CashBookDayData(
      date: json['Date'] ?? "",
      transactions: (json['Transactions'] as List?)
              ?.map((item) => CashBookTransaction.fromJson(item))
              .toList() ??
          [],
      totalDebit: (json['TotalDebit'] ?? 0.0).toDouble(),
      totalCredit: (json['TotalCredit'] ?? 0.0).toDouble(),
      finalBalance: (json['FinalBalance'] ?? 0.0).toDouble(),
      totalOpening: json['TotalOpening'] != null
          ? (json['TotalOpening']).toDouble()
          : null,
      openingBalance: (json['OpeningBalance'] ?? 0.0).toDouble(),
      todayOpeningBalance: (json['TodayOpeningBalance'] ?? 0.0).toDouble(),
      nextDayFinalBalance: (json['NextDayFinalBalance'] ?? 0.0).toDouble(),
    );
  }
}

class CashBookTransaction {
  final int id;
  final String? particularName;
  final String? flag;
  final double amount;
  final double? totalBalance;
  final String? createdatetime;
  final double? openingBalance;
  final String? expenseBowcherNo;
  final String? receiptBowcherNo;
  final String? remark;
  final String? mobileNo;
  final String? remarks;
  final String? image;
  final String? createdBy;
  final String? type;
  final String? voucherNo;

  CashBookTransaction({
    required this.id,
    this.particularName,
    this.flag,
    required this.amount,
    this.totalBalance,
    this.createdatetime,
    this.openingBalance,
    this.expenseBowcherNo,
    this.receiptBowcherNo,
    this.remark,
    this.mobileNo,
    this.remarks,
    this.image,
    this.createdBy,
    this.type,
    this.voucherNo,
  });

  factory CashBookTransaction.fromJson(Map<String, dynamic> json) {
    return CashBookTransaction(
      id: json['id'] ?? 0,
      particularName: json['ParicularName'], // Note spelling from JSON
      flag: json['Flag'],
      amount: (json['Amount'] ?? 0.0).toDouble(),
      totalBalance: json['TotalBalance'] != null
          ? (json['TotalBalance']).toDouble()
          : null,
      createdatetime: json['Createdatetime'],
      openingBalance: json['OpeningBalance'] != null
          ? (json['OpeningBalance']).toDouble()
          : null,
      expenseBowcherNo: json['ExpenceBowcherNo'],
      receiptBowcherNo: json['ReceiptBowcherNo'],
      remark: json['Remark'],
      mobileNo: json['MobileNo'],
      remarks: json['Remarks'],
      image: json['image'],
      createdBy: json['CreatedBy'],
      type: json['Type'],
      voucherNo: json['VoucherNo'],
    );
  }
}
