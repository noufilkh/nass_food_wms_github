class ReceiveEnteredListItem {
  String poNumber;
  String poheaderid;
  String polineid;
  String linelocationid;
  String lineid;
  String inventoryitemid;
  String itemCode;
  String itemDescription;
  String subinventorycode;
  String locatorid;
  String locator;
  String pallet;
  String lotnumber;
  String expirydate;
  String fromserial;
  String toserial;
  String recievedquantity;
  String receivedweight;
  String holdquantity;
  String productiondate;
  String primaryquantity;
  String partnumber;
  String lotenabled;
  String serialenabled;
  String expirydatereq;

  ReceiveEnteredListItem({
    required this.poNumber,
    required this.poheaderid,
    required this.polineid,
    required this.linelocationid,
    required this.lineid,
    required this.inventoryitemid,
    required this.itemCode,
    required this.itemDescription,
    required this.subinventorycode,
    required this.locatorid,
    required this.locator,
    required this.pallet,
    required this.lotnumber,
    required this.expirydate,
    required this.fromserial,
    required this.toserial,
    required this.recievedquantity,
    required this.receivedweight,
    required this.holdquantity,
    required this.productiondate,
    required this.primaryquantity,
    required this.partnumber,
    required this.lotenabled,
    required this.serialenabled,
    required this.expirydatereq,
  });

  factory ReceiveEnteredListItem.fromJson(Map<String, dynamic> json) {
    return ReceiveEnteredListItem(
      poNumber: (json['PO_NUMBER'] == null) ? "" : json['PO_NUMBER'],
      poheaderid: (json['PO_HEADER_ID'] == null) ? "" : json['PO_HEADER_ID'],
      polineid: (json['PO_LINE_ID'] == null) ? "" : json['PO_LINE_ID'],
      linelocationid:
          (json['LINE_LOCATION_ID'] == null) ? "" : json['LINE_LOCATION_ID'],
      lineid: (json['LINE_ID'] == null) ? "" : json['LINE_ID'],
      inventoryitemid:
          (json['INVENTORY_ITEM_ID'] == null) ? "" : json['INVENTORY_ITEM_ID'],
      itemCode: (json['ITEM_CODE'] == null) ? "" : json['ITEM_CODE'],
      itemDescription:
          (json['ITEM_DESCRIPTION'] == null) ? "" : json['ITEM_DESCRIPTION'],
      subinventorycode:
          (json['SUBINVENTORY_CODE'] == null) ? "" : json['SUBINVENTORY_CODE'],
      locatorid: (json['LOCATOR_ID'] == null) ? "" : json['LOCATOR_ID'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      pallet: (json['PALLET'] == null) ? "" : json['PALLET'],
      lotnumber: (json['LOT_NUMBER'] == null) ? "" : json['LOT_NUMBER'],
      expirydate:
          (json['LOT_EXPIRY_DATE'] == null) ? "" : json['LOT_EXPIRY_DATE'],
      fromserial:
          (json['FRM_SERIAL_START'] == null) ? "" : json['FRM_SERIAL_START'],
      toserial:
          (json['FRM_SERIAL_ENDS'] == null) ? "" : json['FRM_SERIAL_ENDS'],

      recievedquantity:
          (json['RECEIVED_QUANTITY'] == null) ? "" : json['RECEIVED_QUANTITY'],
      receivedweight:
          (json['RECEIVED_WEIGHT'] == null) ? "" : json['RECEIVED_WEIGHT'],
      holdquantity:
          (json['HOLD_QUANTITY'] == null) ? "" : json['HOLD_QUANTITY'],

      productiondate:
          (json['PRODUCTION_DATE'] == null) ? "" : json['PRODUCTION_DATE'],
      primaryquantity:
          (json['PRIMARY_QUANTITY'] == null) ? "" : json['PRIMARY_QUANTITY'],
      partnumber: (json['PART_NUMBER'] == null) ? "" : json['PART_NUMBER'],
      lotenabled: (json['PO_NUMBER'] == null) ? "" : json['PO_NUMBER'],
      serialenabled:
          (json['SERIAL_ENABLED'] == null) ? "" : json['SERIAL_ENABLED'],
      expirydatereq: (json['EXP_DATE_REQ'] == null) ? "" : json['EXP_DATE_REQ'],
    );
  }

  // static String _generateRandomString(int length) {
  //   const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   return String.fromCharCodes(
  //     Iterable.generate(
  //       length,
  //       (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
  //     ),
  //   );
  // }

  // final List<String> itemCodes = ['', ''];

  // static List<ReceiveListItem> getReceiveListItems() {
  //   return List.generate(
  //     Random().nextInt(9) + 1,
  //     (index) => ReceiveListItem(
  //       poNumber: _generateRandomString(8),
  //       lineid: Random().nextInt(250).toString(),
  //       itemCode: AppFunctions.getItemCodes[index],
  //       itemDescription: AppFunctions.getItemDescription[index],
  //       orderedquantity: (Random().nextInt(100) + 50).toString(),
  //       recievedquantity: Random().nextInt(50).toString(),
  //       orderedweight: (Random().nextInt(4500) + 850).toString(),
  //       recievedweight: Random().nextInt(250).toString(),
  //     ),
  //   );
  // }
}
