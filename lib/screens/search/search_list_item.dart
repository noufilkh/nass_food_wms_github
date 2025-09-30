class SearchListItem {
  final String itemCode;
  final String itemDescription;
  final String locator;
  final String pallet;
  final double quantity;
  final String uom;
  final String expiryDate;
  final String subinventory;
  final String lotno;

  SearchListItem({
    required this.itemCode,
    required this.itemDescription,
    required this.locator,
    required this.pallet,
    required this.quantity,
    required this.uom,
    required this.expiryDate,
    required this.subinventory,
    required this.lotno,
  });

  factory SearchListItem.fromJson(Map<String, dynamic> json) {
    return SearchListItem(
      itemCode: (json['ITEM_CODE'] == null) ? "" : json['ITEM_CODE'],
      itemDescription:
          (json['ITEM_DESCRIPTION'] == null) ? "" : json['ITEM_DESCRIPTION'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      pallet: (json['PALLET'] == null) ? "" : json['PALLET'] ?? "",
      quantity:
          (json['ONHAND_QUANTITY'] == null)
              ? 0
              : double.tryParse(json['ONHAND_QUANTITY']) ?? 0,

      uom: (json['PRIMARY_UOM'] == null) ? "" : json['PRIMARY_UOM'],
      expiryDate:
          (json['EXPIRATION_DATE'] == null) ? "" : json['EXPIRATION_DATE'],
      subinventory:
          (json['SUBINVENTORY_CODE'] == null) ? "" : json['SUBINVENTORY_CODE'],
      lotno: (json['LOT_NUMBER'] == null) ? "" : json['LOT_NUMBER'],
    );
  }
}
