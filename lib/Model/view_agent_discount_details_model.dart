class ViewAgentDiscountDetailsModel {
  final bool status;
  final String message;
  final InvoiceDetails invoiceDetails;
  final Summary summary;
  final List<InvoiceItem> items;

  ViewAgentDiscountDetailsModel({
    required this.status,
    required this.message,
    required this.invoiceDetails,
    required this.summary,
    required this.items,
  });

  factory ViewAgentDiscountDetailsModel.fromJson(
      Map<String, dynamic> json) {
    return ViewAgentDiscountDetailsModel(
      status: json["Status"] ?? false,
      message: json["Message"] ?? "",
      invoiceDetails:
      InvoiceDetails.fromJson(json["InvoiceDetails"] ?? {}),
      summary: Summary.fromJson(json["Summary"] ?? {}),
      items: (json["Items"] as List?)
          ?.map((e) => InvoiceItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class InvoiceDetails {
  final String billNo;
  final String schoolName;
  final String address;
  final String agentName;
  final String managerName;
  final String transport;
  final String billDate;

  InvoiceDetails({
    required this.billNo,
    required this.schoolName,
    required this.address,
    required this.agentName,
    required this.managerName,
    required this.transport,
    required this.billDate,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      billNo: json["BillNo"] ?? "",
      schoolName: json["SchoolName"] ?? "",
      address: json["Address"] ?? "",
      agentName: json["AgentName"] ?? "",
      managerName: json["ManagerName"] ?? "",
      transport: json["Transport"] ?? "",
      billDate: json["BillDate"] ?? "",
    );
  }
}

class Summary {
  final int totalQty;
  final double grandTotal;
  final double discountPercent;
  final double discountAmount;
  final double afterDiscountTotal;
  final double totalAgentCommission;
  final double totalManagerCommission;

  Summary({
    required this.totalQty,
    required this.grandTotal,
    required this.discountPercent,
    required this.discountAmount,
    required this.afterDiscountTotal,
    required this.totalAgentCommission,
    required this.totalManagerCommission,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalQty: json["TotalQty"] ?? 0,
      grandTotal:
      (json["GrandTotal"] as num?)?.toDouble() ?? 0,
      discountPercent:
      (json["DiscountPercent"] as num?)?.toDouble() ?? 0,
      discountAmount:
      (json["DiscountAmount"] as num?)?.toDouble() ?? 0,
      afterDiscountTotal:
      (json["AfterDiscountTotal"] as num?)?.toDouble() ?? 0,
      totalAgentCommission:
      (json["TotalAgentCommission"] as num?)
          ?.toDouble() ??
          0,
      totalManagerCommission:
      (json["TotalManagerCommission"] as num?)
          ?.toDouble() ??
          0,
    );
  }
}

class InvoiceItem {
  final String bookName;
  final String publication;
  final String classes;
  final String series;
  final int qty;
  final double rate;
  final double totalAmount;

  InvoiceItem({
    required this.bookName,
    required this.publication,
    required this.classes,
    required this.series,
    required this.qty,
    required this.rate,
    required this.totalAmount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      bookName: json["BookName"] ?? "",
      publication: json["Publication"] ?? "",
      classes: json["Classes"] ?? "",
      series: json["Series"] ?? "",
      qty: json["Qty"] ?? 0,
      rate: (json["Rate"] as num?)?.toDouble() ?? 0,
      totalAmount:
      (json["TotalAmount"] as num?)?.toDouble() ?? 0,
    );
  }
}