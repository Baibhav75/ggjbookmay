class PurchaseTitalTabledateModel {
  final String message;
  final ItemData data;

  PurchaseTitalTabledateModel({
    required this.message,
    required this.data,
  });

  factory PurchaseTitalTabledateModel.fromJson(Map<String, dynamic> json) {
    return PurchaseTitalTabledateModel(
      message: json['Message'],
      data: ItemData.fromJson(json['Data']),
    );
  }
}

class ItemData {
  final String itemCode;
  final String itemtitle;
  final double discount;
  final String subject;
  final String board;

  final double rate1;
  final double rate2;
  final double rate3;
  final double rate4;
  final double rate5;

  ItemData({
    required this.itemCode,
    required this.itemtitle,
    required this.discount,
    required this.subject,
    required this.board,
    required this.rate1,
    required this.rate2,
    required this.rate3,
    required this.rate4,
    required this.rate5,
  });

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      itemCode: json['itemCode'],
      itemtitle: json['itemtitle'],
      discount: (json['discount'] as num).toDouble(),
      subject: json['Subject'],
      board: json['Board'],
      rate1: (json['Rate_1'] as num).toDouble(),
      rate2: (json['Rate_2'] as num).toDouble(),
      rate3: (json['Rate_3'] as num).toDouble(),
      rate4: (json['Rate_4'] as num).toDouble(),
      rate5: (json['Rate_5'] as num).toDouble(),
    );
  }
}