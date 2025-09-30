import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/salesreturn/salesreturnlist.dart';

class SalesReturnApiService {
  static Future<List<SalessReturnlist>> returnByOrderNO(
    String orderNumber,
  ) async {
    orderNumber = orderNumber.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/salesreturnview/$orderNumber',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["salesreturnview"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<SalessReturnlist>.empty();
    }

    List<dynamic> searchItems = searchjson["salesreturnview"];
    List<SalessReturnlist> searchitemlist =
        searchItems.map((data) => SalessReturnlist.fromJson(data)).toList();
    return searchitemlist;
  }

  static Future<String> salesreturnupdate(
    String headerid,
    String lineid,
    String enteredquantity,
  ) async {
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/salesreturn');

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );

    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'salesreturn': [
        {
          'HeaderID': headerid,
          'LineID': lineid,
          'Qty': enteredquantity,
          'OrganizationID': orgid,
          'UserID': userid,
        },
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        return 'Success';
      } else {
        return result['msg'];
      }
    } else {
      return "Some Error found";
    }
  }

  static Future<String> salesreturnconfirm(
    String headerid,
    String reason,
  ) async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/confirmreturn',
    );

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );

    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'confirmreturn': [
        {
          'HeaderID': headerid,
          'Reason': reason,
          'OrganizationID': orgid,
          'UserID': userid,
        },
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        return 'Success';
      } else {
        return result['msg'];
      }
    } else {
      return "Some Error found";
    }
  }
}
