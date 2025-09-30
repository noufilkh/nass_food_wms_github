class ReceiveListItem {
  final String poNumber;
  final String lineid;
  final String itemCode;
  final String itemDescription;
  double orderedquantity;
  double enteredquantity;
  double pendingquantity;
  String supliername;
  String linelocationid;
  String lotenabled;
  String serialenabled;
  String lastproductiondate;
  String lastexpirydate;

  ReceiveListItem({
    required this.poNumber,
    required this.lineid,
    required this.itemCode,
    required this.itemDescription,
    required this.orderedquantity,
    required this.enteredquantity,
    required this.pendingquantity,
    required this.supliername,
    required this.linelocationid,
    required this.lotenabled,
    required this.serialenabled,
    required this.lastproductiondate,
    required this.lastexpirydate,
  });

  factory ReceiveListItem.fromJson(Map<String, dynamic> json) {
    return ReceiveListItem(
      poNumber: (json['PO_NUMBER'] == null) ? "" : json['PO_NUMBER'],
      lineid: (json['LINE_ID'] == null) ? "" : json['LINE_ID'],
      itemCode: (json['ITEM_CODE'] == null) ? "" : json['ITEM_CODE'],
      itemDescription:
          (json['ITEM_DESCRIPTION'] == null) ? "" : json['ITEM_DESCRIPTION'],
      orderedquantity:
          (json['ORDERED_QUANTITY'] == null)
              ? 0
              : double.tryParse(json['ORDERED_QUANTITY']) ?? 0,
      enteredquantity:
          (json['ENTERED_QTY'] == null)
              ? 0
              : double.tryParse(json['ENTERED_QTY']) ?? 0,

      pendingquantity:
          (json['PENDING_QTY'] == null)
              ? 0
              : double.tryParse(json['PENDING_QTY']) ?? 0,
      supliername: (json['SUP_NAME'] == null) ? "" : json['SUP_NAME'],
      linelocationid:
          (json['LINE_LOCATION_ID'] == null) ? "" : json['LINE_LOCATION_ID'],
      lotenabled: (json['LOT_ENABLED'] == null) ? "" : json['LOT_ENABLED'],
      serialenabled:
          (json['SERIAL_ENABLED'] == null) ? "" : json['SERIAL_ENABLED'],
      lastproductiondate:
          (json['LAST_PROD_DATE'] == null) ? "" : json['LAST_PROD_DATE'],
      lastexpirydate:
          (json['LAST_EXP_DATE'] == null) ? "" : json['LAST_EXP_DATE'],
    );
  }
}
