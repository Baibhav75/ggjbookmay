class PurchaseSeriesInvoiceModel {
  final String message;
  final List<SeriesItem> data;

  PurchaseSeriesInvoiceModel({
    required this.message,
    required this.data,
  });

  factory PurchaseSeriesInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PurchaseSeriesInvoiceModel(
      message: json['Message'],
      data: (json['Data'] as List)
          .map((e) => SeriesItem.fromJson(e))
          .toList(),
    );
  }
}

class SeriesItem {
  final String series;
  final String seriesId;

  SeriesItem({
    required this.series,
    required this.seriesId,
  });

  factory SeriesItem.fromJson(Map<String, dynamic> json) {
    return SeriesItem(
      series: json['Series'],
      seriesId: json['SeriesId'],
    );
  }
}