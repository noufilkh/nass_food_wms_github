import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/recieve/list_item_recieve.dart';
import 'package:food_wms/screens/recieve/list_item_recieve_entered.dart';
import 'package:food_wms/screens/recieve/list_shipment.dart';

class RecieveApiService {
  static Future<List<ReceiveListItem>> receivedbyPO(String poNumber) async {
    poNumber = poNumber.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/wmspendingpo/$poNumber',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["PendingPO"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<ReceiveListItem>.empty();
    }

    List<dynamic> searchItems = searchjson["PendingPO"];
    List<ReceiveListItem> searchitemlist =
        searchItems.map((data) => ReceiveListItem.fromJson(data)).toList();
    return searchitemlist;
  }

  static Future<List<ReceiveEnteredListItem>> receivedEnteredbyPO(
    String poNumber,
    String itemcode,
  ) async {
    poNumber = poNumber.trim();
    itemcode = itemcode.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/wmspendingrecpt/$poNumber/$itemcode',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["PendingReceipt"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<ReceiveEnteredListItem>.empty();
    }

    List<dynamic> searchItems = searchjson["PendingReceipt"];
    List<ReceiveEnteredListItem> searchitemlist =
        searchItems
            .map((data) => ReceiveEnteredListItem.fromJson(data))
            .toList();
    return searchitemlist;
  }

  static Future<String> recievedItemsInsert(
    String organizationid,
    String linelocationid,
    String? receiptNumber,
    String? subinvenotyrcode,
    String locator,
    String quntity,
    String lotno,
    String expirydate,
    String? fromSerialNo,
    String? toSerialNo,
    String? remarks,
    String pallet,
    String? weight,
    String proddate,
    String? holdqunatity,
    String userid,
    String? lineid,
  ) async {
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/wmsmrrinsert');

    final body = {
      'WmsMrrInsert': [
        {
          'OrganizationID': organizationid,
          'LineLocatorID': linelocationid,
          'ReceiptNumber': receiptNumber,
          'SubInventoryCode': subinvenotyrcode,
          'Locator': locator,
          'Qty': quntity,
          'LotNo': lotno,
          'LotExpDate': expirydate,
          'FromSlNo1': fromSerialNo,
          'FromSlNo2': toSerialNo,
          'Remarks': remarks,
          'Pallet': pallet,
          'Weight': weight,
          'ProdDate': proddate,
          'HoldQty': holdqunatity,
          'UserID': userid,
          'LineID': lineid,
        },
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    final returndata = await ApiService.post(url, body, headers, true);

    if (returndata['status'] != null) {
      if (returndata['status'] == 'Ok') {
        return 'Success';
      } else {
        return returndata['msg'];
      }
    } else {
      return 'Some Error found';
    }
  }

  static Future<String> deliveryDetailsupdate(
    String lineid,
    String orderquantity,
    String ctnquantity,
    String weight,
  ) async {
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/updatesodtls');

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );
    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'updatesodtls': [
        {
          'OrganizationID': orgid,
          'LineID': lineid,
          'UserID': userid,

          'OrderQty': orderquantity,
          'CtnQty': ctnquantity,
          'Weight': weight,
        },
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        return 'Success';
      } else {
        List<dynamic> error = result["Update SoDetails"];
        if (error.isNotEmpty) {
          List<dynamic> innerList = error[0];
          if (innerList.isNotEmpty) {
            String recordMessage = innerList[0];
            return recordMessage;
          } else {
            return "Some Error found";
          }
        } else {
          return "Some Error found";
        }
      }
    } else {
      return "Some Error found";
    }
  }

  static Future<ShipmentListItem> getshipment(String poNumber) async {
    poNumber = poNumber.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/wmsreceiptinfo/$poNumber',
    );

    final searchjson = await ApiService.get(url);
    ShipmentListItem emptyitem = ShipmentListItem(
      ponumber: '',
      mrrfileno: '',
      mode: '',
      modedescription: '',
      country: '',
      countrydescription: '',
      date: '',
      reference: '',
    );

    if (searchjson["wmsreceiptinfo"] == null ||
        searchjson["msg"] == 'No Items found') {
      return emptyitem;
    }

    List<dynamic> searchItems = searchjson["wmsreceiptinfo"];
    List<ShipmentListItem> searchitemlist =
        searchItems.map((data) => ShipmentListItem.fromJson(data)).toList();
    if (searchitemlist.isEmpty) return emptyitem;

    return searchitemlist[0];
  }

  static Future<List<ShipmentModeListItem>> getAllshipmentmode() async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/shipmentmodes',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["shipmentmodes"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<ShipmentModeListItem>.empty();
    }

    List<dynamic> searchItems = searchjson["shipmentmodes"];
    List<ShipmentModeListItem> searchitemlist =
        searchItems.map((data) => ShipmentModeListItem.fromJson(data)).toList();
    return searchitemlist;
  }

  static Future<List<ShipmentCountryListItem>> getAllcountry() async {
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/wmscountry');

    final searchjson = await ApiService.get(url);

    if (searchjson["wmscountry"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<ShipmentCountryListItem>.empty();
    }

    List<dynamic> searchItems = searchjson["wmscountry"];
    List<ShipmentCountryListItem> searchitemlist =
        searchItems
            .map((data) => ShipmentCountryListItem.fromJson(data))
            .toList();
    return searchitemlist;
  }

  static Future<String> shipmentsupdate(
    String ponumber,
    String mrrfileno,
    String shipmentmode,
    String country,
    String reference,
    String date,
  ) async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/insertreceiptinfo',
    );

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );
    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'insertreceiptinfo': [
        {
          'OrganizationID': orgid,
          'PoNumber': ponumber,
          'UserID': userid,
          'MRRFileNo': mrrfileno,
          'ShipmentMode': shipmentmode,
          'ShipmentCountry': country,
          'ShipmentRef': reference,
          'ShipmentDate': date,
        },
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'OK') {
        return 'Success';
      } else {
        List<dynamic> error = result["Insert Receipt Info"];
        if (error.isNotEmpty) {
          List<dynamic> innerList = error[0];
          if (innerList.isNotEmpty) {
            String recordMessage = innerList[0];
            return recordMessage;
          } else {
            return "Some Error found";
          }
        } else {
          return "Some Error found";
        }
      }
    } else {
      return "Some Error found";
    }
  }
}
