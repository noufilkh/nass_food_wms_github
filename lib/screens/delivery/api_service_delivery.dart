import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/delivery/list_item_delivery_locator.dart';
import 'package:food_wms/screens/delivery/list_item_delivery_pallet_items.dart';

class DeliveryApiService {
  static Future<List<DeliveryLocatorListItem>> locatorByDeliveryNO(
    String deliveryNumber,
  ) async {
    deliveryNumber = deliveryNumber.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/wmspendinglines/$deliveryNumber',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["PendingLines"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<DeliveryLocatorListItem>.empty();
    }

    List<dynamic> searchItems = searchjson["PendingLines"];
    List<DeliveryLocatorListItem> searchitemlist =
        searchItems
            .map((data) => DeliveryLocatorListItem.fromJson(data))
            .toList();
    return searchitemlist;
  }

  static Future<List<DeliveryPalletItemsListItem>>
  palletitemsByDeliveryNOAndLocator(String deliveryNumber, int locator) async {
    deliveryNumber = deliveryNumber.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/wmspendinglineslocator/$deliveryNumber/$locator',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["PendingReceipt"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<DeliveryPalletItemsListItem>.empty();
    }

    List<dynamic> searchItems = searchjson["PendingReceipt"];
    List<DeliveryPalletItemsListItem> searchitemlist =
        searchItems
            .map((data) => DeliveryPalletItemsListItem.fromJson(data))
            .toList();
    return searchitemlist;
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

  static Future<String> deliveryconfirmation(String deliveryno) async {
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/confirmso');

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );
    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'confirmso': [
        {'OrganizationID': orgid, 'UserID': userid, 'OrderNo': deliveryno},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        return 'Success';
      } else {
        List<dynamic> error = result["So Confirmation"];
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
