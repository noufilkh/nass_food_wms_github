import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/search/search_list_item.dart';
import 'package:http/http.dart' as http;

class ApiService {
  //static final String baseUrl = 'https://jsonplaceholder.typicode.com';
  static final String baseUrl = 'https://localhost:8095/api';

  static refreshtoken() async {
    final data = await testHoConnection();
    String token = data['access_token'];
    int expiry = data['expires_in'];
    DateTime expdate = DateTime.now().add(Duration(seconds: expiry));

    await SharedPreferencesHelper.saveString(
      SharedPreferencesHelper.KEY_TOKEN,
      token,
    );

    await SharedPreferencesHelper.saveString(
      SharedPreferencesHelper.KEY_TOKENEXP,
      expdate.toString(),
    );
  }

  // HTTP GET function
  static Future<dynamic> get(Uri url) async {
    try {
      String token = SharedPreferencesHelper.loadString(
        SharedPreferencesHelper.KEY_TOKEN,
      );

      DateTime expiry = DateTime.parse(
        SharedPreferencesHelper.loadString(
          SharedPreferencesHelper.KEY_TOKENEXP,
        ),
      );

      if (expiry.isBefore(DateTime.now())) {
        await refreshtoken();
        token = SharedPreferencesHelper.loadString(
          SharedPreferencesHelper.KEY_TOKEN,
        );
      }

      Map<String, String> header = {'Authorization': 'Bearer $token'};
      final response = await http.get(url, headers: header);

      // debugPrint("statusCode : ${response.statusCode}");
      // debugPrint("response : ${jsonDecode(response.body)}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      //debugPrint("Error : ${e.toString()}");
      throw Exception('Error: $e');
    }
  }

  // HTTP POST function
  // static Future<dynamic> _post2(
  //   String endpoint,
  //   Map<String, dynamic> data,
  // ) async {
  //   final url = Uri.parse('$baseUrl$endpoint');
  //   print("Url : $url");
  //   print("postData : $data");

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(data),
  //     );

  //     final jsonbody = jsonDecode(response.body);

  //     print("statusCode : ${response.statusCode}");
  //     print("jsonbody : $jsonbody");

  //     if (response.statusCode == 200) {
  //       return jsonbody;
  //     } else {
  //       throw Exception(jsonbody["resultmessage"].toString());
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  static Future<dynamic> post(
    Uri url,
    Map<String, dynamic> body,
    Map<String, String> header,
    bool useToken,
  ) async {
    try {
      if (useToken) {
        String token = SharedPreferencesHelper.loadString(
          SharedPreferencesHelper.KEY_TOKEN,
        );

        DateTime expiry = DateTime.parse(
          SharedPreferencesHelper.loadString(
            SharedPreferencesHelper.KEY_TOKENEXP,
          ),
        );

        if (expiry.isBefore(DateTime.now())) {
          await refreshtoken();
          token = SharedPreferencesHelper.loadString(
            SharedPreferencesHelper.KEY_TOKEN,
          );
        }

        header = {'Authorization': 'Bearer $token'};
      }

      // debugPrint("Url : $url");
      // debugPrint("body : $body");
      // debugPrint("body : ${jsonEncode(body)}");
      // debugPrint("header : $header");

      final http.Response response;

      if (!useToken) {
        response = await http.post(url, headers: header, body: body);
      } else {
        response = await http.post(
          url,
          headers: header,
          body: jsonEncode(body),
        );
      }
      // debugPrint("Response statusCode : ${response.statusCode}");
      // debugPrint("Response body : ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonbody = jsonDecode(response.body);
        return jsonbody;
      } else if (response.statusCode == 404) {
        throw Exception('Request URL not found');
      } else {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        throw Exception(jsonResponse['msg']);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<dynamic> testHoConnection() async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/client_credentials.php/access_token',
    );

    final body = {
      'grant_type': 'client_credentials',
      'client_id': 'nassfoods_app',
      'client_secret': 'Nassfoods@\$669',
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    return post(url, body, headers, false);
  }

  static Future<dynamic> getItemsMaster() async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/NFitemmaster/2206',
    );
    return get(url);
  }

  static Future<List<SearchListItem>> searchItems(
    String itemcode,
    String locator,
    String pallet,
  ) async {
    itemcode = itemcode.trim();
    locator = locator.trim();
    final url = Uri.parse('https://api.aanass.net/auth/apiNF.php/ItemSearch');

    final body = {
      'ItemSearch': [
        {'Itemcode': itemcode, 'Locator': locator},
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    final searchjson = await post(url, body, headers, true);

    if (searchjson["Item Details"] == null) {
      return List<SearchListItem>.empty();
    }
    List<dynamic> searchItems = searchjson["Item Details"];
    List<SearchListItem> searchitemlist =
        searchItems.map((data) => SearchListItem.fromJson(data)).toList();
    return searchitemlist;
  }

  

  

  

  static Future<dynamic> recievedItemsConfirmation(
    String organizationid,
    String ponumber,
    String userid,
  ) async {
    final url = Uri.parse(
      'https://api.aanass.net/auth/apiNF.php/confirmporeceipt',
    );

    final body = {
      'confirmporeceipt': [
        {
          'PoNumber': ponumber,
          'OrganizationID': organizationid,
          'UserID': userid,
        },
      ],
    };

    final headers = {'Content-Type': 'application/x-www-form-urlencoded'};

    return await post(url, body, headers, true);
  }
}
