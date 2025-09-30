import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  String subtext = '';

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    initStatemethod();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initStatemethod() async {
    try {
      //await _db();
      await _checkApiAndNavigate();
    } catch (error) {
      AppFunctions.showError(context, 'An error occurred: $error');
    }
  }

  // Future<void> _db() async {
  //   // Get an instance of the DatabaseHelper
  //   DatabaseHelper dbHelper = DatabaseHelper();

  //   // Initialize the database
  //   Database db = await dbHelper.database;
  //   print('Database initialized or already exists.');
  // }

  Future<void> _checkApiAndNavigate() async {
    try {
      setState(() {
        subtext = "Testing connection with HO";
      });

      final data = await ApiService.testHoConnection();
      String token = data['access_token'];
      int expiry = data['expires_in'];      

      //Map<String, dynamic> tokendata = AppFunctions.decodeToken(token);
      //DateTime expdate = tokendata['exp'];
      if (token.isEmpty || expiry == 0) {
        setState(() {
          subtext = "Connection with HO failed";
        });
        return;
      }

      DateTime expdate = DateTime.now().add(Duration(seconds: expiry));

      setState(() {
        subtext = "Connection with HO is successful";
      });
      await SharedPreferencesHelper.saveString(
        SharedPreferencesHelper.KEY_TOKEN,
        token,
      );

      await SharedPreferencesHelper.saveString(
        SharedPreferencesHelper.KEY_TOKENEXP,
        expdate.toString(),
      );

      // List<Map<String, dynamic>> allitems =
      //     await DatabaseHelper().getAllItems();

      // print('total items : ${allitems.length}');

      // final items = await ApiService.getitems();

      // List<dynamic> listitems = items['ItemMaster'];
      // int itemcount = listitems.length;
      // int start = 1;
      // String itemcode = '';
      // String itemdescription = '';

      // for (var item in listitems) {
      //   itemcode = item['ITEMCODE'];
      //   itemdescription = '$itemcode - ${item['DESCRIPTION']}';
      //   itemcode = itemcode.replaceAll("'", "''");

      //   if (allitems.where((x) => x.containsValue(itemcode)).isEmpty) {
      //     setState(() {
      //       subtext = "Downloading item $start of $itemcount";
      //     });

      //     await DatabaseHelper().insertItem({
      //       DatabaseHelper.itemCode: itemcode,
      //       DatabaseHelper.itemDescription: itemdescription,
      //     });
      //   }

      //   start = start + 1;
      // }

      Future.delayed(Duration(seconds: 1), () {
        AppRoutes.redirectlogin(context);
      });
    } catch (error) {
      setState(() {
        subtext = "Connection with HO failed";
      });      
      AppFunctions.showError(context, 'An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RotationTransition(
              turns: _rotationAnimation,
              child: Icon(
                Icons.warehouse,
                size: 120,
                color: AppTheme.accentColor,
              ),
              // Image.asset(
              //   'assets/food_logo.jpg', // Replace with your actual logo image path
              //   height: 150,
              // ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nass Food WMS',
              style: TextStyle(
                color: AppTheme.backgroundColor,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtext,
              style: TextStyle(
                color: AppTheme.backgroundColor,
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const SpinKitCircle(color: AppTheme.backgroundColor, size: 50.0),
          ],
        ),
      ),
    );
  }
}
