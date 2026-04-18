class StockRegisterModel {
  final String status;
  final String publicationName;
  final List<StockItem> data;
  final Totals totals;

  StockRegisterModel({
    required this.status,
    required this.publicationName,
    required this.data,
    required this.totals,
  });

  factory StockRegisterModel.fromJson(Map<String, dynamic> json) {
    return StockRegisterModel(
      status: json['status'] ?? "",
      publicationName: json['PublicationName'] ?? "",
      data: (json['data'] as List)
          .map((e) => StockItem.fromJson(e))
          .toList(),
      totals: Totals.fromJson(json['totals']),
    );
  }
}

class StockItem {
  final String publicationName;
  final String seriesName;
  final String bookName;
  final int purchaseQty;
  final int purchaseReturnQty;
  final int saleQty;
  final int saleReturnQty;
  final int stock;
  final double rate;
  final double amount;

  StockItem({
    required this.publicationName,
    required this.seriesName,
    required this.bookName,
    required this.purchaseQty,
    required this.purchaseReturnQty,
    required this.saleQty,
    required this.saleReturnQty,
    required this.stock,
    required this.rate,
    required this.amount,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      publicationName: json['PublicationName'] ?? "",
      seriesName: json['SeriesName'] ?? "",
      bookName: json['BookName'] ?? "",
      purchaseQty: json['PurchaseQty'] ?? 0,
      purchaseReturnQty: json['PurchaseReturnQty'] ?? 0,
      saleQty: json['SaleQty'] ?? 0,
      saleReturnQty: json['SaleReturnQty'] ?? 0,
      stock: json['Stock'] ?? 0,
      rate: (json['Rate'] ?? 0).toDouble(),
      amount: (json['Amount'] ?? 0).toDouble(),
    );
  }
}

class Totals {
  final int totalPurchase;
  final int totalPurchaseReturn;
  final int totalSale;
  final int totalSaleReturn;
  final int totalStock;
  final double totalAmount;

  Totals({
    required this.totalPurchase,
    required this.totalPurchaseReturn,
    required this.totalSale,
    required this.totalSaleReturn,
    required this.totalStock,
    required this.totalAmount,
  });

  factory Totals.fromJson(Map<String, dynamic> json) {
    return Totals(
      totalPurchase: json['TotalPurchase'] ?? 0,
      totalPurchaseReturn: json['TotalPurchaseReturn'] ?? 0,
      totalSale: json['TotalSale'] ?? 0,
      totalSaleReturn: json['TotalSaleReturn'] ?? 0,
      totalStock: json['TotalStock'] ?? 0,
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
    );
  }
}