import 'package:flutter/widgets.dart';

class StockCheckListItem2 {
  final String stockcheckid;
  final String locator;
  final String pallet;
  final String itemCode;
  final String itemDescription;
  final double quantity;
  final TextEditingController enteredquantity;
  final double weight;
  final TextEditingController enteredwieght;
  bool isquanentered;
  bool isweightentered;

  StockCheckListItem2({
    required this.stockcheckid,
    required this.locator,
    required this.pallet,
    required this.itemCode,
    required this.itemDescription,
    required this.quantity,
    required this.enteredquantity,
    required this.weight,
    required this.enteredwieght,
    required this.isquanentered,
    required this.isweightentered,
  });
}
