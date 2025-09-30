import 'package:flutter/material.dart';
import 'package:food_wms/screens/delivery/list_item_delivery_pallet_items.dart';
import 'package:food_wms/screens/delivery/screen_delivery.dart';
import 'package:food_wms/screens/delivery/screen_delivery_locator.dart';
import 'package:food_wms/screens/delivery/screen_delivery_pallet.dart';
import 'package:food_wms/screens/home_screen.dart';
import 'package:food_wms/login/login_screen.dart';
import 'package:food_wms/screens/recieve/screen_receive_entered.dart';
import 'package:food_wms/screens/recieve/screen_receive_entered_search.dart';
import 'package:food_wms/screens/recieve/screen_receive.dart';
import 'package:food_wms/screens/recieve/screen_receive_search.dart';
import 'package:food_wms/screens/recieve/list_item_recieve_entered.dart';
import 'package:food_wms/screens/recieve/list_item_recieve.dart';
import 'package:food_wms/screens/relocate_items/relocate_item_screen.dart';
import 'package:food_wms/screens/relocate_items/relocate_pallet_screen.dart';
import 'package:food_wms/screens/salesreturn/sales_return_screen.dart';
import 'package:food_wms/screens/search/search_item_screen.dart';
import 'package:food_wms/screens/splash_screen.dart';
import 'package:food_wms/screens/stock_check/stock_check_locator_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String searchitem = '/searchitem';
  static const String receive = '/receive';
  static const String enteredreceive = '/enteredreceive';
  static const String delivery = '/delivery';
  static const String relocatepallet = '/relocatepallet';
  static const String relocateitems = '/relocateitems';
  static const String stockcheck = '/stockcheck';
  static const String salesreturn = '/salesreturn';
  static const String splashscreen = '/splashscreen';

  static Map<String, Widget Function(BuildContext)> routes = {
    login: (context) => const LoginScreen(title: 'Login'),
    home: (context) => const HomeScreen(),
    searchitem: (context) => const SearchItemScreen(title: 'Search Item'),
    receive: (context) => const ReceiveSearchScreen(title: 'Receive'),
    delivery: (context) => const DeliveryLocatorSearchScreen(title: 'Delivery'),
    relocatepallet:
        (context) => const RelocatePalletScreen(title: 'Relocate Pallet'),
    relocateitems:
        (context) => const RelocateItemScreen(title: 'Relocate Item'),
    stockcheck:
        (context) => const StockCheckLocatorScreen(title: 'Stock Check'),
    salesreturn: (context) => const SalesReturnScreen(title: 'Sales Return'),
    splashscreen: (context) => const SplashScreen(),
  };

  static redirectlogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static redirectlogoff(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static redirecthome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static redirectsearchitem(BuildContext context) {
    Navigator.pushNamed(context, searchitem);
  }

  static redirectrecieve(BuildContext context) {
    Navigator.pushNamed(context, receive);
  }

  static redirectdelivery(BuildContext context) {
    Navigator.pushNamed(context, delivery);
  }

  static redirectrelocatepallet(BuildContext context) {
    Navigator.pushNamed(context, relocatepallet);
  }

  static redirectrelocateitems(BuildContext context) {
    Navigator.pushNamed(context, relocateitems);
  }

  static redirectstockcheck(BuildContext context) {
    Navigator.pushNamed(context, stockcheck);
  }

  static redirectsalesreturn(BuildContext context) {
    Navigator.pushNamed(context, salesreturn);
  }

  static redirectsplashscreen(BuildContext context) {
    Navigator.pushNamed(context, splashscreen);
  }

  static redirectrecieveitems(
    BuildContext context,
    ReceiveListItem recieveitem,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReceiveScreen(item: recieveitem)),
    );
  }

  static redirectenteredSearchrecieveitem(
    BuildContext context,
    ReceiveListItem receivelistitem,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ReceiveEnteredSearchScreen(
              title: 'PO Item Details',
              item: receivelistitem,
            ),
      ),
    );
  }

  static dynamic redirectenteredrecieveitem(
    BuildContext context,
    ReceiveEnteredListItem receivelistitem,
    double totalquantity,
    double orderedquantity,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ReceiveEnteredScreen(
              item: receivelistitem,
              totalenteredquantity: totalquantity,
              totalorderedquantity: orderedquantity,
            ),
      ),
    );
    return result;
  }

  static dynamic redirectdeliverypalletitems(
    BuildContext context,
    String deliveryNo,
    String locator,
    int locatorid,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DeliveryPalletSearchScreen(
              deliveryNo: deliveryNo,
              locator: locator,
              locatorid: locatorid,
            ),
      ),
    );
    return result;
  }

  static dynamic redirectdeliveryScreen(
    BuildContext context,
    String deliveryNo,
    String locator,
    DeliveryPalletItemsListItem item,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DeliveryScreen(
              deliveryNo: deliveryNo,
              locator: locator,
              listitem: item,
            ),
      ),
    );
    return result;
  }
}
