import 'package:flutter/widgets.dart';

class SalessReturnlist {
  final String orderno;
  final String orderdate;
  final String headerid;
  final String lineid;
  final String itemcode;
  final String itemdescription;
  final String subinventory;
  final String lotnumber;
  final String primaryquantity;
  final String primaryuom;  
  final String linexists;
  TextEditingController enteredquantity;
  bool? isquanentered;

  SalessReturnlist({
    required this.orderno,
    required this.orderdate,
    required this.headerid,
    required this.lineid,
    required this.itemcode,
    required this.itemdescription,
    required this.subinventory,
    required this.lotnumber,
    required this.primaryquantity,
    required this.primaryuom,    
    required this.linexists,
    required this.enteredquantity,
  });

  factory SalessReturnlist.fromJson(Map<String, dynamic> json) {
    return SalessReturnlist(
      orderno: (json['ORDER_NUMBER'] == null) ? "" : json['ORDER_NUMBER'],
      orderdate: (json['ORDERED_DATE'] == null) ? "" : json['ORDERED_DATE'],
      headerid: (json['HEADER_ID'] == null) ? "" : json['HEADER_ID'],
      lineid: (json['LINE_ID'] == null) ? "" : json['LINE_ID'],
      itemcode: (json['ITEM_CODE'] == null) ? "" : json['ITEM_CODE'],
      itemdescription:
          (json['ITEM_DESCRIPTION'] == null) ? "" : json['ITEM_DESCRIPTION'],
      subinventory:
          (json['SUBINVENTORY_CODE'] == null) ? "" : json['SUBINVENTORY_CODE'],
      lotnumber: (json['LOT_NUMBER'] == null) ? "" : json['LOT_NUMBER'],
      primaryquantity:
          (json['PRIMARY_QUANTITY'] == null) ? "" : json['PRIMARY_QUANTITY'],
      primaryuom: (json['PRIMARY_UOM'] == null) ? "" : json['PRIMARY_UOM'],      
      linexists: (json['LINE_EXISTS'] == null) ? "" : json['LINE_EXISTS'],
      enteredquantity: TextEditingController(
        text: (json['ENTERED_QTY'] == null) ? "" : json['ENTERED_QTY'],
      ),
    );
  }
}
