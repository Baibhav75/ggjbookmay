class PurchasePublicationEntryModel {
  final bool status;
  final String message;
  final List<PublicationItem> publicationList;

  PurchasePublicationEntryModel({
    required this.status,
    required this.message,
    required this.publicationList,
  });

  factory PurchasePublicationEntryModel.fromJson(Map<String, dynamic> json) {
    return PurchasePublicationEntryModel(
      status: json['Status'],
      message: json['Message'],
      publicationList: (json['PublicationList'] as List)
          .map((e) => PublicationItem.fromJson(e))
          .toList(),
    );
  }
}

class PublicationItem {
  final String publication;
  final String publicationId;

  PublicationItem({
    required this.publication,
    required this.publicationId,
  });

  factory PublicationItem.fromJson(Map<String, dynamic> json) {
    return PublicationItem(
      publication: json['Publication'],
      publicationId: json['PublicationId'],
    );
  }
}