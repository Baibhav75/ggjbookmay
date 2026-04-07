class PurchasePartyEntryModel {
  final String publication;
  final String publicationId;
  final String group;

  PurchasePartyEntryModel({
    required this.publication,
    required this.publicationId,
    required this.group,
  });

  factory PurchasePartyEntryModel.fromJson(Map<String, dynamic> json) {
    return PurchasePartyEntryModel(
      publication: json['Publication'] ?? '',
      publicationId: json['PublicationId'] ?? '',
      group: json['Groups'] ?? '',
    );
  }
}