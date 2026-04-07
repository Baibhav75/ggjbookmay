class GetMixReportPubDiscModel {
  final String publication;
  final List<MixReportItem> data;

  GetMixReportPubDiscModel({
    required this.publication,
    required this.data,
  });

  factory GetMixReportPubDiscModel.fromJson(Map<String, dynamic> json) {
    return GetMixReportPubDiscModel(
      publication: json['Publication'] ?? '',
      data: (json['Data'] as List? ?? [])
          .map((e) => MixReportItem.fromJson(e))
          .toList(),
    );
  }
}

class MixReportItem {
  final String publication;
  final String series;
  final String bookName;
  final int purchaseQty;
  final int returnQty;
  final int netQty;
  final double rate;
  final double amount;
  final double discount;
  final double netAmount;

  MixReportItem({
    required this.publication,
    required this.series,
    required this.bookName,
    required this.purchaseQty,
    required this.returnQty,
    required this.netQty,
    required this.rate,
    required this.amount,
    required this.discount,
    required this.netAmount,
  });

  factory MixReportItem.fromJson(Map<String, dynamic> json) {
    return MixReportItem(
      publication: json['Publication'] ?? '',
      series: json['Series'] ?? '',
      bookName: json['BookName'] ?? '',
      purchaseQty: int.tryParse(json['PurchaseQty'].toString()) ?? 0,
      returnQty: int.tryParse(json['ReturnQty'].toString()) ?? 0,
      netQty: int.tryParse(json['NetQty'].toString()) ?? 0,
      rate: double.tryParse(json['Rate'].toString()) ?? 0,
      amount: double.tryParse(json['Amount'].toString()) ?? 0,
      discount: double.tryParse(json['Discount'].toString()) ?? 0,
      netAmount: double.tryParse(json['NetAmount'].toString()) ?? 0,
    );
  }
}