class ItemMasterList {
  final String itemCode;
  final String itemDescription;

  ItemMasterList({required this.itemCode, required this.itemDescription});

  factory ItemMasterList.fromJson(Map<String, dynamic> json) {
    return ItemMasterList(
      itemCode: (json['ITEMCODE'] == null) ? "" : json['ITEMCODE'],
      itemDescription: (json['DESCRIPTION'] == null) ? "" : json['DESCRIPTION'],
    );
  }
}
