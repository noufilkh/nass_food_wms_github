import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';

class RelocateItemsApiService {
  static Future<String> relocateitemupdate(
    String itemcode,
    String frompallet,
    String fromlocator,
    String fromsubinventory,
    String topallet,
    String tolocator,
    String tosubinventory,
  ) async {
    final url = Uri.parse('https://localhost:8095/api/auth/apiNF.php/relocateitem');

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );

    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'relocateitem': [
        {
          'OrganizationID': orgid,
          'UserID': userid,
          'Itemcode': itemcode,
          'FromPallet': frompallet,
          'FromLocator': fromlocator,
          'FromSubInv': fromsubinventory,
          'ToPallet': topallet,
          'ToLocator': tolocator,
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

  static Future<String> relocatepalletupdate(
    String frompallet,
    String fromlocator,
    String tolocator,
  ) async {
    final url = Uri.parse('https://localhost:8095/api/auth/apiNF.php/relocatepallet');

    final orgid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGID,
    );

    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'relocatepallet': [
        {
          'OrganizationID': orgid,
          'UserID': userid,          
          'FromPallet': frompallet,
          'FromLocator': fromlocator,          
          'ToLocator': tolocator,
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
