class ViewSaleReturnDetailResponse {
  final String status;
  final String message;
  final SaleReturnInvoice invoice;
  final List<SaleReturnSeriesGroup> seriesGroups;
  final int grandTotalQty;
  final double grandTotal;
  final double discountPercent;
  final double totalDiscountAmount;
  final double finalAmount;

  ViewSaleReturnDetailResponse({
    required this.status,
    required this.message,
    required this.invoice,
    required this.seriesGroups,
    required this.grandTotalQty,
    required this.grandTotal,
    required this.discountPercent,
    required this.totalDiscountAmount,
    required this.finalAmount,
  });

  factory ViewSaleReturnDetailResponse.fromJson(
      Map<String, dynamic> json) {
    return ViewSaleReturnDetailResponse(
      status: json["Status"] ?? "",
      message: json["Message"] ?? "",
      invoice: SaleReturnInvoice.fromJson(json["Invoice"] ?? {}),
      seriesGroups: (json["SeriesGroups"] as List? ?? [])
          .map((e) => SaleReturnSeriesGroup.fromJson(e))
          .toList(),
      grandTotalQty: json["GrandTotalQty"] ?? 0,
      grandTotal:
      double.tryParse(json["GrandTotal"].toString()) ?? 0,
      discountPercent:
      double.tryParse(json["DiscountPercent"].toString()) ?? 0,
      totalDiscountAmount:
      double.tryParse(json["TotalDiscountAmount"].toString()) ?? 0,
      finalAmount:
      double.tryParse(json["FinalAmount"].toString()) ?? 0,
    );
  }
}

class SaleReturnInvoice {
  final String billNo;
  final String partyName;
  final String address;
  final String transport;
  final String createdBy;
  final String billDate;
  final String recDate;

  SaleReturnInvoice({
    required this.billNo,
    required this.partyName,
    required this.address,
    required this.transport,
    required this.createdBy,
    required this.billDate,
    required this.recDate,
  });

  factory SaleReturnInvoice.fromJson(Map<String, dynamic> json) {
    return SaleReturnInvoice(
      billNo: json["BillNo"] ?? "",
      partyName: json["PartyName"] ?? "",
      address: json["Address"] ?? "",
      transport: json["Transport"] ?? "",
      createdBy: json["CreatedBy"] ?? "",
      billDate: json["BillDate"] ?? "",
      recDate: json["RecDate"] ?? "",
    );
  }
}

class SaleReturnSeriesGroup {
  final String series;
  final String publication;
  final int seriesQty;
  final double seriesTotal;
  final double seriesDiscountAmount;
  final double seriesNetAmount;
  final List<SaleReturnItem> items;

  SaleReturnSeriesGroup({
    required this.series,
    required this.publication,
    required this.seriesQty,
    required this.seriesTotal,
    required this.seriesDiscountAmount,
    required this.seriesNetAmount,
    required this.items,
  });

  factory SaleReturnSeriesGroup.fromJson(
      Map<String, dynamic> json) {
    return SaleReturnSeriesGroup(
      series: json["Series"] ?? "",
      publication: json["Publication"] ?? "",
      seriesQty: json["SeriesQty"] ?? 0,
      seriesTotal:
      double.tryParse(json["SeriesTotal"].toString()) ?? 0,
      seriesDiscountAmount:
      double.tryParse(json["SeriesDiscountAmount"].toString()) ?? 0,
      seriesNetAmount:
      double.tryParse(json["SeriesNetAmount"].toString()) ?? 0,
      items: (json["Items"] as List? ?? [])
          .map((e) => SaleReturnItem.fromJson(e))
          .toList(),
    );
  }
}

class SaleReturnItem {
  final String bookName;
  final String subject;
  final String classes;
  final int qty;
  final double rate;
  final double discount;
  final String publication;
  final String series;
  final double amount;
  final double discountAmt;
  final double netAmount;

  SaleReturnItem({
    required this.bookName,
    required this.subject,
    required this.classes,
    required this.qty,
    required this.rate,
    required this.discount,
    required this.publication,
    required this.series,
    required this.amount,
    required this.discountAmt,
    required this.netAmount,
  });

  factory SaleReturnItem.fromJson(Map<String, dynamic> json) {
    return SaleReturnItem(
      bookName: json["BookName"] ?? "",
      subject: json["Subject"] ?? "",
      classes: json["Classes"] ?? "",
      qty: json["Qty"] ?? 0,
      rate: double.tryParse(json["Rate"].toString()) ?? 0,
      discount:
      double.tryParse(json["discount"].toString()) ?? 0,
      publication: json["Publication"] ?? "",
      series: json["Series"] ?? "",
      amount: double.tryParse(json["Amount"].toString()) ?? 0,
      discountAmt:
      double.tryParse(json["DiscountAmt"].toString()) ?? 0,
      netAmount:
      double.tryParse(json["NetAmount"].toString()) ?? 0,
    );
  }
}