import 'package:flutter/material.dart';

class Stockchecklocatorlist {
  final String transactionno;
  final String transactiondate;
  final String majorcategory;
  final String minorcategory;
  final String headerid;
  final String organizationid;
  final String locatorid;
  final String locator;
  final String totalquantity;
  final String verifiedcount;

  Stockchecklocatorlist({
    required this.transactionno,
    required this.transactiondate,
    required this.majorcategory,
    required this.minorcategory,
    required this.headerid,
    required this.organizationid,
    required this.locatorid,
    required this.locator,
    required this.totalquantity,
    required this.verifiedcount,
  });

  factory Stockchecklocatorlist.fromJson(Map<String, dynamic> json) {
    return Stockchecklocatorlist(
      transactionno:
          (json['TRANSACTION_NO'] == null) ? "" : json['TRANSACTION_NO'],
      transactiondate:
          (json['TRANSACTION_DATE'] == null) ? "" : json['TRANSACTION_DATE'],
      majorcategory:
          (json['MAJOR_CATEGORY'] == null) ? "" : json['MAJOR_CATEGORY'],
      minorcategory:
          (json['MINOR_CATEGORY'] == null) ? "" : json['MINOR_CATEGORY'],
      headerid: (json['HEADER_ID'] == null) ? "" : json['HEADER_ID'],
      organizationid:
          (json['ORGANIZATION_ID'] == null) ? "" : json['ORGANIZATION_ID'],
      locatorid: (json['LOCATOR_ID'] == null) ? "" : json['LOCATOR_ID'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      totalquantity: (json['TOTA_CNT'] == null) ? "" : json['TOTA_CNT'],
      verifiedcount: (json['VERIFIED_CNT'] == null) ? "" : json['VERIFIED_CNT'],
    );
  }
}

class StockcheckPalletlist {
  final String transactionno;
  final String transactiondate;
  final String pallet;
  final String locator;
  final String locatorid;
  final String itemcount;

  StockcheckPalletlist({
    required this.transactionno,
    required this.transactiondate,
    required this.pallet,
    required this.locator,
    required this.locatorid,
    required this.itemcount,
  });

  factory StockcheckPalletlist.fromJson(Map<String, dynamic> json) {
    return StockcheckPalletlist(
      transactionno:
          (json['TRANSACTION_NO'] == null) ? "" : json['TRANSACTION_NO'],
      transactiondate:
          (json['TRANSACTION_DATE'] == null) ? "" : json['TRANSACTION_DATE'],
      pallet: (json['PALLET'] == null) ? "" : json['PALLET'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      locatorid: (json['LOCATOR_ID'] == null) ? "" : json['LOCATOR_ID'],
      itemcount: (json['ITEM_COUNT'] == null) ? "" : json['ITEM_COUNT'],
    );
  }
}

class Stockcheckitemslist {
  final String transactionno;
  final String transactiondate;
  final String majorcategory;
  final String minorcategory;
  final String headerid;
  final String organizationid;
  final String lineid;
  final String linenumber;
  final String inventoryitemid;
  final String itemcode;
  final String itemdescription;
  final String partnumber;
  final String lotnumber;
  final String subinventorycode;
  final String locatorid;
  final String locator;
  final String pallet;
  final String serialnumber;
  final String onhandquantity;
  final String primaryuom;
  final String verifiedquantity;
  final String linestatus;
  final TextEditingController enteredquantity;
  bool isquantityentered;

  Stockcheckitemslist({
    required this.transactionno,
    required this.transactiondate,
    required this.majorcategory,
    required this.minorcategory,
    required this.headerid,
    required this.organizationid,
    required this.lineid,
    required this.linenumber,
    required this.inventoryitemid,
    required this.itemcode,
    required this.itemdescription,
    required this.partnumber,
    required this.lotnumber,
    required this.subinventorycode,
    required this.locatorid,
    required this.locator,
    required this.pallet,
    required this.serialnumber,
    required this.onhandquantity,
    required this.primaryuom,
    required this.verifiedquantity,
    required this.linestatus,
    required this.enteredquantity,
    required this.isquantityentered,
  });

  factory Stockcheckitemslist.fromJson(Map<String, dynamic> json) {
    return Stockcheckitemslist(
      transactionno:
          (json['TRANSACTION_NO'] == null) ? "" : json['TRANSACTION_NO'],

      transactiondate:
          (json['TRANSACTION_DATE'] == null) ? "" : json['TRANSACTION_DATE'],
      majorcategory:
          (json['MAJOR_CATEGORY'] == null) ? "" : json['MAJOR_CATEGORY'],
      minorcategory:
          (json['MINOR_CATEGORY'] == null) ? "" : json['MINOR_CATEGORY'],
      headerid: (json['HEADER_ID'] == null) ? "" : json['HEADER_ID'],
      organizationid:
          (json['ORGANIZATION_ID'] == null) ? "" : json['ORGANIZATION_ID'],
      lineid: (json['LINE_ID'] == null) ? "" : json['LINE_ID'],
      linenumber: (json['LINE_NUMBER'] == null) ? "" : json['LINE_NUMBER'],
      inventoryitemid:
          (json['INVENTORY_ITEM_ID'] == null) ? "" : json['INVENTORY_ITEM_ID'],
      itemcode: (json['ITEM_CODE'] == null) ? "" : json['ITEM_CODE'],
      itemdescription:
          (json['ITEM_DESCRIPTION'] == null) ? "" : json['ITEM_DESCRIPTION'],
      partnumber: (json['PART_NUMBER'] == null) ? "" : json['PART_NUMBER'],
      lotnumber: (json['LOT_NUMBER'] == null) ? "" : json['LOT_NUMBER'],
      subinventorycode:
          (json['SUBINVENTORY_CODE'] == null) ? "" : json['SUBINVENTORY_CODE'],
      locatorid: (json['LOCATOR_ID'] == null) ? "" : json['LOCATOR_ID'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      pallet: (json['PALLET'] == null) ? "" : json['PALLET'],
      serialnumber:
          (json['SERIAL_NUMBER'] == null) ? "" : json['SERIAL_NUMBER'],
      onhandquantity:
          (json['ONHAND_QUANTITY'] == null) ? "" : json['ONHAND_QUANTITY'],
      primaryuom: (json['PRIMARY_UOM'] == null) ? "" : json['PRIMARY_UOM'],
      verifiedquantity:
          (json['VERIFIED_QUANTITY'] == null) ? "" : json['VERIFIED_QUANTITY'],
      linestatus: (json['LINE_STATUS'] == null) ? "" : json['LINE_STATUS'],
      enteredquantity: TextEditingController(
        text:
            (json['VERIFIED_QUANTITY'] == null)
                ? ""
                : json['VERIFIED_QUANTITY'],
      ),
      isquantityentered: false,
    );
  }
}

class Stockcheckupdatelist {
  final String headerid;
  final String lineid;
  final String verifiedquantity;

  Stockcheckupdatelist({
    required this.headerid,
    required this.lineid,
    required this.verifiedquantity,
  });
}

class StockcheckupdateErrorlist {  
  final String lineid;
  final String message;

  StockcheckupdateErrorlist({    
    required this.lineid,
    required this.message,
  });
}
