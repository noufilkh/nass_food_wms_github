class DeliveryPalletItemsListItem {
  final String headerid;
  final String lineid;
  final String inventoryitemid;
  final String itemcode;
  final String itemdescription;
  final String subinventorycode;
  final String lotno;
  final String expirydate;
  final String primaryquantity;
  final String primaryuom;
  final String orderedquantity;
  final String orderedquantityuom;
  final String cartonquantity;
  final String netweight;
  final String locator;
  final String locatorid;
  final String pallet;
  final String enteredquantity;
  final String enteredctnquantity;
  final String enteredweight;

  DeliveryPalletItemsListItem({
    required this.headerid,
    required this.lineid,
    required this.inventoryitemid,
    required this.itemcode,
    required this.itemdescription,
    required this.subinventorycode,
    required this.lotno,
    required this.expirydate,
    required this.primaryquantity,
    required this.primaryuom,
    required this.orderedquantity,
    required this.orderedquantityuom,
    required this.cartonquantity,
    required this.netweight,
    required this.locator,
    required this.locatorid,
    required this.pallet,
    required this.enteredquantity,
    required this.enteredctnquantity,
    required this.enteredweight,
  });

  factory DeliveryPalletItemsListItem.fromJson(Map<String, dynamic> json) {
    return DeliveryPalletItemsListItem(
      headerid: (json['HEADER_ID'] == null) ? "" : json['HEADER_ID'],
      lineid: (json['LINE_ID'] == null) ? "" : json['LINE_ID'],
      inventoryitemid:
          (json['INVENTORY_ITEM_ID'] == null) ? "" : json['INVENTORY_ITEM_ID'],
      itemcode: (json['ITEM_CODE'] == null) ? "" : json['ITEM_CODE'],
      itemdescription:
          (json['ITEM_DESCRIPTION'] == null) ? "" : json['ITEM_DESCRIPTION'],
      subinventorycode:
          (json['SUBINVENTORY_CODE'] == null) ? "" : json['SUBINVENTORY_CODE'],
      lotno: (json['LOT_NUMBER'] == null) ? "" : json['LOT_NUMBER'],
      expirydate: (json['EXPIRY_DATE'] == null) ? "" : json['EXPIRY_DATE'],
      primaryquantity:
          (json['PRIMARY_QUANTITY'] == null) ? "" : json['PRIMARY_QUANTITY'],
      primaryuom: (json['PRIMARY_UOM'] == null) ? "" : json['PRIMARY_UOM'],
      orderedquantity:
          (json['ORDERED_QUANTITY'] == null) ? "" : json['ORDERED_QUANTITY'],
      orderedquantityuom:
          (json['ORDERED_UOM'] == null) ? "" : json['ORDERED_UOM'],
      cartonquantity: (json['CARTON_QTY'] == null) ? "" : json['CARTON_QTY'],
      netweight: (json['NET_WEIGHT'] == null) ? "" : json['NET_WEIGHT'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      locatorid: (json['LOCATOR_ID'] == null) ? "" : json['LOCATOR_ID'],
      pallet: (json['PALLET'] == null) ? "" : json['PALLET'],
      enteredquantity:
          (json['ENETERED_QTY'] == null) ? "" : json['ENETERED_QTY'],
      enteredctnquantity:
          (json['ENTERED_CTN_QTY'] == null) ? "" : json['ENTERED_CTN_QTY'],
      enteredweight:
          (json['ENTERED_WEIGHT'] == null) ? "" : json['ENTERED_WEIGHT'],
    );
  }
}
