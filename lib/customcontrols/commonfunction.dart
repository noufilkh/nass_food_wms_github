import 'dart:core';

import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appdatabasehelper.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppFunctions {
  static final EdgeInsets textfieldbottompadding = EdgeInsets.only(bottom: 10);
  static final IconData locator = Icons.shelves;
  static final IconData pallet = Icons.pallet;
  static final int orgid = 2206;

  static String? validateNonEmpty(String? value, String label) {
    if (value == null || value.isEmpty) {
      return '$label cannot be empty';
    }
    return null;
  }

  static String? validatePositiveNumber(String? value, String label) {
    if (value == null || value.isEmpty) {
      return '$label cannot be empty';
    }
    final number = num.tryParse(value);
    if (number == null || number <= 0) {
      return '$label must be greater than 0';
    }
    return null;
  }

  static Map<String, dynamic> decodeToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    Map<String, dynamic> returninfo = {};

    if (decodedToken.containsKey('exp')) {
      DateTime expiration = DateTime.fromMillisecondsSinceEpoch(
        decodedToken['exp'] * 1000,
      );

      returninfo.addEntries({
        MapEntry('exp', expiration),
        MapEntry('expdate', expiration.toString()),
        MapEntry('isexpired', JwtDecoder.isExpired(token)),
      });
    }

    return returninfo;
  }

  static bool isValidToken() {
    String strtokenexp = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_TOKENEXP,
    );

    if (strtokenexp.isEmpty) {
      return false;
    }

    DateTime tokenexp = DateTime.parse(strtokenexp);

    if (tokenexp.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  static Widget footer(BuildContext context) {
    String sessionstr = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_TOKENEXP,
    );
    String session = DateFormat(
      'dd-MMM-yyyy hh:mm a',
    ).format(DateTime.parse(sessionstr));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              'Your session will expire after : $session',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  static List<String> getItemCodes = [
    '1402903930611',
    '6084000123550',
    '1202205510002',
    '1202100110003',
    '1201906410005',
    '1101600110008',
    '1602903931210',
    '1604204520105',
    '1700105510808',
    '1700497110212',
    '1700608610601',
    '1700608610610',
    '1700805512009',
    '2107297110012',
    '2306603210403',
    '2606297111010',
    '3205497130103',
  ];

  static List<String> getItemDescription = [
    'MARA TOMATO PASTE 22/24 (6X2200GRAMS) 6X2200 GM',
    'BFM SELF RAISIN FLOUR (Packet)',
    'CONCEPTION FROZEN BEEF CUBE ROLL	(Kilograms)',
    'CANADIAN FROZEN BEEF TENDERLOIN B/L AAA (Kilograms)',
    '27599 FROZEN NZ BEEF RIBEYE ROLL 4-6KG	(Kilograms)',
    'MIDAMAR HICKORY SMOKED TURKEY BREAST (2-8.5 LB AVG.)	2-8.5LB	(Kilograms)',
    'MARA POMACE OLIVE OIL (12X1LIT)	12X1 LIT	Carton',
    'FRIENDSHIP DANISH FETA CHEESE (1X16KG)	1X16 KG	Carton',
    'PENA BRANCA FROZEN GRILLER CHICKEN 1500 GRAMS	8X1500 GM	Carton',
    'BIBI CHICKEN WINGS BUFFALO (2X5KG)	2X5 KG	Carton',
    'HEIFOOD FROZEN CHICKEN BREAST B/L S/L (2KG)	6x2KG	Carton',
    'HEIFOOD CHINA DUCK 13.80 KG	6X2.3 KG	Carton',
    'ZEINA FROZEN CHICKEN LIVER (20X450GRAMS)	20X450 GMS	Carton',
    'HAMMOUR FILLET 300/UP	4X2.5 KG	Kilograms',
    '4WAY-TOMEX MIXED VEGETABLES (4X2.5KG)	4X2.5 KG	Carton',
    '12" FLOUR TORTILLAS WHOLE WHEAT	10X1 DOZ	Carton',
    'CORIANDER POWDER 15KG	15 KG	Bag',
  ];

  static Future<List<String>> getSuggestions(String pattern) async {
    List<String> items = List.empty(growable: true);
    List<Map<String, dynamic>> searchlist = await DatabaseHelper()
        .getAllItemsByPattern(pattern);

    for (var element in searchlist) {
      items.add(element[DatabaseHelper.itemDescription]);
    }

    return items;
  }

  static Future<void> showAlertloading(
    BuildContext context,
    String text,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // User can't dismiss by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircularProgressIndicator(color: AppTheme.accentColor),
                    ],
                  ),
                  Expanded(flex: 1, child: Column(children: [Text(text)])),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          content: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30,
                  ),
                ), // Success icon
                Expanded(child: Text(message, style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        );
      },
    );
  }

  

  static void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showAlertDialog(BuildContext context, returndata) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is an example of an alert dialog.'),
                Text('You can display multiple lines of text here.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
