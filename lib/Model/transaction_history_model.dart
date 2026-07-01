class TransactionHistoryResponse {
  final bool status;
  final TransactionSummary summary;
  final List<TransactionData> data;

  TransactionHistoryResponse({
    required this.status,
    required this.summary,
    required this.data,
  });

  factory TransactionHistoryResponse.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryResponse(
      status: json['Status'] ?? false,
      summary: TransactionSummary.fromJson(json['Summary'] ?? {}),
      data: (json['Data'] as List?)
              ?.map((item) => TransactionData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class TransactionSummary {
  final double openingBalance;
  final double totalCredit;
  final double totalDebit;
  final double totalTransaction;
  final double netBalance;
  final double finalNetBalance;

  TransactionSummary({
    required this.openingBalance,
    required this.totalCredit,
    required this.totalDebit,
    required this.totalTransaction,
    required this.netBalance,
    required this.finalNetBalance,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      openingBalance: (json['OpeningBalance'] ?? 0.0).toDouble(),
      totalCredit: (json['TotalCredit'] ?? 0.0).toDouble(),
      totalDebit: (json['TotalDebit'] ?? 0.0).toDouble(),
      totalTransaction: (json['TotalTransaction'] ?? 0.0).toDouble(),
      netBalance: (json['NetBalance'] ?? 0.0).toDouble(),
      finalNetBalance: (json['FinalNetBalance'] ?? 0.0).toDouble(),
    );
  }
}

class TransactionData {
  final int id;
  final String bankName;
  final String accountNumber;
  final String type;
  final String toPayment;
  final String description;
  final double deposit;
  final double withdrawal;
  final double amount;
  final String createdBy;
  final bool isBulk;
  final String? publicationName;
  final String? schoolName;
  final String? vendorName;
  final String paymentDate;
  final String transactionDate;
  final String transactionDateRaw;

  TransactionData({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.type,
    required this.toPayment,
    required this.description,
    required this.deposit,
    required this.withdrawal,
    required this.amount,
    required this.createdBy,
    required this.isBulk,
    this.publicationName,
    this.schoolName,
    this.vendorName,
    required this.paymentDate,
    required this.transactionDate,
    required this.transactionDateRaw,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['Id'] ?? 0,
      bankName: json['BankName'] ?? '',
      accountNumber: json['AccountNumber'] ?? '',
      type: json['Type'] ?? '',
      toPayment: json['Topayment'] ?? '',
      description: json['Description'] ?? '',
      deposit: (json['Deposit'] ?? 0.0).toDouble(),
      withdrawal: (json['Withdrawal'] ?? 0.0).toDouble(),
      amount: (json['Amount'] ?? 0.0).toDouble(),
      createdBy: json['CreatedBy'] ?? '',
      isBulk: json['IsBulk'] ?? false,
      publicationName: json['PublicationName'],
      schoolName: json['SchoolName'],
      vendorName: json['VendorName'],
      paymentDate: json['PaymentDate'] ?? '',
      transactionDate: json['TransactionDate'] ?? '',
      transactionDateRaw: json['TransactionDateRaw'] ?? '',
    );
  }
}
