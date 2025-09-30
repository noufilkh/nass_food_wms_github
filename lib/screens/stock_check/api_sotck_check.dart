import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/stock_check/stockchecklist.dart';

class StockCheckApiService {
  static Future<List<Stockchecklocatorlist>> getlocatorbystockcheckno(
    String stockcheckno,
  ) async {
    stockcheckno = stockcheckno.trim();

    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/stockverify/$stockcheckno',
    );

    final searchjson = await ApiService.get(url);

    if (searchjson["StockVerify"] == null ||
        searchjson["msg"] == 'No Items found') {
      return List<Stockchecklocatorlist>.empty();
    }

    List<dynamic> searchItems = searchjson["StockVerify"];
    List<Stockchecklocatorlist> searchitemlist =
        searchItems
            .map((data) => Stockchecklocatorlist.fromJson(data))
            .toList();
    return searchitemlist;
  }

  static Future<List<StockcheckPalletlist>> getpalletbystockcheckno(
    String stockcheckno,
    String locator,
  ) async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/phycheckpallet',
    );
    final body = {
      'phycheckpallet': [
        {'Transaction_no': stockcheckno, 'Locator': locator},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        List<dynamic> searchItems = result["phycheckpallet"];
        List<StockcheckPalletlist> searchitemlist =
            searchItems
                .map((data) => StockcheckPalletlist.fromJson(data))
                .toList();
        return searchitemlist;
      } else {
        throw Exception(result['msg']);
      }
    } else {
      throw Exception("Some Error found");
    }
  }

  static Future<List<Stockcheckitemslist>> getpalletitemsbystockcheckno(
    String stockcheckno,
    String locator,
    String pallet,
  ) async {
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/stockcheck');
    final body = {
      'stockcheck': [
        {'Transaction_no': stockcheckno, 'Locator': locator, 'Pallet': pallet},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        List<dynamic> searchItems = result["Stock check"];
        List<Stockcheckitemslist> searchitemlist =
            searchItems
                .map((data) => Stockcheckitemslist.fromJson(data))
                .toList();
        return searchitemlist;
      } else {
        throw Exception(result['msg']);
      }
    } else {
      throw Exception("Some Error found");
    }
  }

  static Future<List<StockcheckupdateErrorlist>> stockcheckupdate(
    List<Stockcheckupdatelist> updatelist,
  ) async {
    List<StockcheckupdateErrorlist> errormessage = [];
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/updatephyqty');

    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    List<Map<String, dynamic>> listbody =
        updatelist
            .map(
              (item) => {
                'HeaderID': item.headerid,
                'LineID': item.lineid,
                'Quantity': item.verifiedquantity,
                'UserID': userid,
              },
            )
            .toList();

    final body = {'updatephyqty': listbody};
    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        List<dynamic> resultmsg = result["Update Confirmation"];
        if (resultmsg.isNotEmpty) {
          List<dynamic> recordMessage = resultmsg[0];
          int messagelength = recordMessage.length;

          for (int i = 0; i < messagelength; i++) {
            dynamic element = recordMessage[i];
            int? message = int.tryParse(element.toString());

            if (message == null) {
              if (element != 'SUCCESS') {
                errormessage.add(
                  StockcheckupdateErrorlist(
                    lineid: recordMessage[i - 1].toString(),
                    message: element,
                  ),
                );
              }
            }
          }
        }
      } else {
        errormessage.add(
          StockcheckupdateErrorlist(lineid: '', message: result['msg']),
        );
      }
    } else {
      errormessage.add(
        StockcheckupdateErrorlist(lineid: '', message: 'Some Error found'),
      );
    }

    return errormessage;
  }

  static Future<List<String>> stockcheckconfirm(String headerid) async {
    List<String> errormessage = [];
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/confirmcheck');

    final userid = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERID,
    );

    final body = {
      'confirmcheck': [
        {'HeaderID': headerid, 'UserID': userid},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    final result = await ApiService.post(url, body, headers, true);

    if (result['status'] != null) {
      if (result['status'] == 'Ok') {
        List<dynamic> resultmsg = result["Update Confirmation"];
        if (resultmsg.isNotEmpty) {
          List<dynamic> recordMessage = resultmsg[0];
          int messagelength = recordMessage.length;

          for (int i = 0; i < messagelength; i++) {
            dynamic element = recordMessage[i];
            if (element != 'SUCCESS') {
              errormessage.add(element);
            }
          }
        }
      } else {
        errormessage.add(result['msg']);
      }
    } else {
      errormessage.add('Some Error found');
    }

    return errormessage;
  }
}
