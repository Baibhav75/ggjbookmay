class SaleSampleNotForSaleInvoiceResponse {
  final InvoiceData invoice;
  final List<SeriesGroup> seriesGroups;
  final int grandTotalQty;
  final double grandTotal;
  final double discountPercent;
  final double grandDiscountAmount;
  final double afterDiscountTotal;

  SaleSampleNotForSaleInvoiceResponse({
    required this.invoice,
    required this.seriesGroups,
    required this.grandTotalQty,
    required this.grandTotal,
    required this.discountPercent,
    required this.grandDiscountAmount,
    required this.afterDiscountTotal,
  });

  factory SaleSampleNotForSaleInvoiceResponse.fromJson(Map<String, dynamic> json) {
    return SaleSampleNotForSaleInvoiceResponse(
      invoice: InvoiceData.fromJson(json['Invoice'] ?? {}),
      seriesGroups: (json['SeriesGroups'] as List?)?.map((e) => SeriesGroup.fromJson(e)).toList() ?? [],
      grandTotalQty: json['GrandTotalQty'] ?? 0,
      grandTotal: (json['GrandTotal'] as num?)?.toDouble() ?? 0.0,
      discountPercent: (json['DiscountPercent'] as num?)?.toDouble() ?? 0.0,
      grandDiscountAmount: (json['GrandDiscountAmount'] as num?)?.toDouble() ?? 0.0,
      afterDiscountTotal: (json['AfterDiscountTotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class InvoiceData {
  final String billNo;
  final String partyName; // "SchoolName" in JSON
  final String address;
  final String transport;
  final String remark;
  final String createdBy;
  final String billDate;
  final String recDate;
  final String timeTaken;

  InvoiceData({
    required this.billNo,
    required this.partyName,
    required this.address,
    required this.transport,
    required this.remark,
    required this.createdBy,
    required this.billDate,
    required this.recDate,
    required this.timeTaken,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      billNo: json['BillNo'] ?? '',
      partyName: json['SchoolName'] ?? '',
      address: json['Address'] ?? '',
      transport: json['Transport'] ?? '',
      remark: json['Remark'] ?? '',
      createdBy: json['CreatedBy'] ?? '',
      billDate: json['BillDate'] ?? '',
      recDate: json['RecDate'] ?? '',
      timeTaken: json['TimeTaken'] ?? '',
    );
  }
}

class SeriesGroup {
  final String series;
  final String publication;
  final double seriesTotal;
  final double seriesDiscount;
  final double seriesDiscountAmount;
  final double afterDiscount;
  final int seriesQty;
  final List<InvoiceItem> items;

  SeriesGroup({
    required this.series,
    required this.publication,
    required this.seriesTotal,
    required this.seriesDiscount,
    required this.seriesDiscountAmount,
    required this.afterDiscount,
    required this.seriesQty,
    required this.items,
  });

  factory SeriesGroup.fromJson(Map<String, dynamic> json) {
    return SeriesGroup(
      series: json['Series'] ?? '',
      publication: json['Publication'] ?? '',
      seriesTotal: (json['SeriesTotal'] as num?)?.toDouble() ?? 0.0,
      seriesDiscount: (json['SeriesDiscount'] as num?)?.toDouble() ?? 0.0,
      seriesDiscountAmount: (json['SeriesDiscountAmount'] as num?)?.toDouble() ?? 0.0,
      afterDiscount: (json['AfterDiscount'] as num?)?.toDouble() ?? 0.0,
      seriesQty: json['SeriesQty'] ?? 0,
      items: (json['Items'] as List?)?.map((e) => InvoiceItem.fromJson(e)).toList() ?? [],
    );
  }
}

class InvoiceItem {
  final String bookName;
  final String subject;
  final String classes;
  final int qty;
  final double rate;
  final double discount;
  final double amount;
  final double netAmount;

  InvoiceItem({
    required this.bookName,
    required this.subject,
    required this.classes,
    required this.qty,
    required this.rate,
    required this.discount,
    required this.amount,
    required this.netAmount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      bookName: json['BookName'] ?? '',
      subject: json['Subject'] ?? '',
      classes: json['Classes'] ?? '',
      qty: json['Qty'] ?? 0,
      rate: (json['Rate'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      amount: (json['Amount'] as num?)?.toDouble() ?? 0.0,
      netAmount: (json['NetAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
