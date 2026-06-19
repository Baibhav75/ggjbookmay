class SampleSaleLedgerResponse {
  final String status;
  final String message;
  final School school;
  final List<LedgerItem> data;
  final double totalDebit;
  final double totalCredit;
  final double closingBalance;

  SampleSaleLedgerResponse({
    required this.status,
    required this.message,
    required this.school,
    required this.data,
    required this.totalDebit,
    required this.totalCredit,
    required this.closingBalance,
  });

  factory SampleSaleLedgerResponse.fromJson(Map<String, dynamic> json) {
    return SampleSaleLedgerResponse(
      status: json['Status'] ?? '',
      message: json['Message'] ?? '',
      school: School.fromJson(json['School'] ?? {}),
      data: (json['Data'] as List<dynamic>? ?? [])
          .map((e) => LedgerItem.fromJson(e))
          .toList(),
      totalDebit: (json['TotalDebit'] ?? 0).toDouble(),
      totalCredit: (json['TotalCredit'] ?? 0).toDouble(),
      closingBalance: (json['ClosingBalance'] ?? 0).toDouble(),
    );
  }
}

class School {
  final int id;
  final String refName;
  final String ownerName;
  final String principalName;
  final String ownerNo;
  final String principalNo;
  final double openingBalance;
  final String balanceType;
  final String address;
  final String district;
  final String blocks;
  final String area;
  final String recoveryAgent;
  final String transportName;
  final String fileNo;
  final String type;
  final String state;
  final String tahsil;
  final String accode;
  final String accName;
  final String schoolId;
  final String gstno;
  final String panNo;

  School({
    required this.id,
    required this.refName,
    required this.ownerName,
    required this.principalName,
    required this.ownerNo,
    required this.principalNo,
    required this.openingBalance,
    required this.balanceType,
    required this.address,
    required this.district,
    required this.blocks,
    required this.area,
    required this.recoveryAgent,
    required this.transportName,
    required this.fileNo,
    required this.type,
    required this.state,
    required this.tahsil,
    required this.accode,
    required this.accName,
    required this.schoolId,
    required this.gstno,
    required this.panNo,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] ?? 0,
      refName: json['RefName'] ?? '',
      ownerName: json['OwnerName'] ?? '',
      principalName: json['PrincipalName'] ?? '',
      ownerNo: json['OwnerNo'] ?? '',
      principalNo: json['PrincipalNo'] ?? '',
      openingBalance: (json['OpeningBalance'] ?? 0).toDouble(),
      balanceType: json['BalanceType'] ?? '',
      address: json['Addresss'] ?? '',
      district: json['District'] ?? '',
      blocks: json['Blocks'] ?? '',
      area: json['Area'] ?? '',
      recoveryAgent: json['RecoveryAgent'] ?? '',
      transportName: json['TransportName'] ?? '',
      fileNo: json['FileNo'] ?? '',
      type: json['Type'] ?? '',
      state: json['State'] ?? '',
      tahsil: json['Tahsil'] ?? '',
      accode: json['Accode'] ?? '',
      accName: json['AccName'] ?? '',
      schoolId: json['SchoolId'] ?? '',
      gstno: json['Gstno'] ?? '',
      panNo: json['PanNo'] ?? '',
    );
  }
}

class LedgerItem {
  final int id;
  final String date;
  final int vchNo;
  final String type;
  final String? billNo;
  final double balance;
  final String particulars;
  final double debit;
  final double credit;
  final String remark;

  LedgerItem({
    required this.id,
    required this.date,
    required this.vchNo,
    required this.type,
    this.billNo,
    required this.balance,
    required this.particulars,
    required this.debit,
    required this.credit,
    required this.remark,
  });

  factory LedgerItem.fromJson(Map<String, dynamic> json) {
    return LedgerItem(
      id: json['id'] ?? 0,
      date: json['Date'] ?? '',
      vchNo: json['VchNo'] ?? 0,
      type: json['Type'] ?? '',
      billNo: json['BillNo'],
      balance: (json['Balance'] ?? 0).toDouble(),
      particulars: json['Particulars'] ?? '',
      debit: (json['Debit'] ?? 0).toDouble(),
      credit: (json['Credit'] ?? 0).toDouble(),
      remark: json['Remark'] ?? '',
    );
  }
}