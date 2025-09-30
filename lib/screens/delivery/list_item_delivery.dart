import 'dart:math';

import 'package:food_wms/customcontrols/commonfunction.dart';

class DeliryListItem {
  final String poNumber;
  final String lineid;
  final String itemCode;
  final String itemDescription;
  final String orderedquantity;
  final String recievedquantity;
  final String orderedweight;
  final String recievedweight;

  DeliryListItem({
    required this.poNumber,
    required this.lineid,
    required this.itemCode,
    required this.itemDescription,
    required this.orderedquantity,
    required this.recievedquantity,
    required this.orderedweight,
    required this.recievedweight,
  });

  static String _generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
      ),
    );
  }

  final List<String> itemCodes = ['', ''];

  static List<DeliryListItem> getReceiveListItems() {
    return List.generate(
      Random().nextInt(9) + 1,
      (index) => DeliryListItem(
        poNumber: _generateRandomString(8),
        lineid: Random().nextInt(9).toString(),
        itemCode: AppFunctions.getItemCodes[index],
        itemDescription: AppFunctions.getItemDescription[index],
        orderedquantity: (Random().nextInt(100) + 50).toString(),
        recievedquantity: Random().nextInt(50).toString(),
        orderedweight: (Random().nextInt(4500) + 850).toString(),
        recievedweight: Random().nextInt(250).toString(),
      ),
    );
  }
}
