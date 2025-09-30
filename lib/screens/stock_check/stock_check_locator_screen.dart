import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/stock_check/api_sotck_check.dart';
import 'package:food_wms/screens/stock_check/stock_check_pallet_screen.dart';
import 'package:food_wms/screens/stock_check/stockchecklist.dart';

class StockCheckLocatorScreen extends StatefulWidget {
  final String title;

  const StockCheckLocatorScreen({super.key, required this.title});

  @override
  State<StockCheckLocatorScreen> createState() =>
      _StockCheckLocatorScreenState();
}

class _StockCheckLocatorScreenState extends State<StockCheckLocatorScreen> {
  final TextEditingController stockcheckController = TextEditingController();
  List<Stockchecklocatorlist> orgstockchecklist = List.empty(growable: true);
  List<Stockchecklocatorlist> stockchecklist = List.empty(growable: true);
  bool _isLoading = false;
  bool isallowreceipt = false;
  String headerid = '';

  @override
  void initState() {
    super.initState();
    final allowreceipt = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERALLOWRECIEPTID,
    );
    isallowreceipt = allowreceipt == 'Y' ? true : false;
  }

  Future<void> loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      orgstockchecklist = await StockCheckApiService.getlocatorbystockcheckno(
        stockcheckController.text,
      );

      headerid =
          orgstockchecklist.isNotEmpty ? orgstockchecklist[0].headerid : '';

      setState(() {
        _isLoading = false;
        stockchecklist =
            orgstockchecklist.isEmpty
                ? List.empty(growable: true)
                : orgstockchecklist;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppFunctions.showError(context, e.toString());
    }
  }

  void confirm(BuildContext context, String headerid) async {
    try {
      await AppFunctions.showAlertloading(context, 'Please wait..');

      await Future.delayed(Duration(seconds: 1));

      List<String> error = await StockCheckApiService.stockcheckconfirm(
        headerid,
      );

      Navigator.of(context).pop();

      if (error.isEmpty) {
        AppFunctions.showSuccessDialog(
          context,
          'Stock Check Confirmed Successfully',
        );
      } else {
        String errorMessage = error.join(', ');
        AppFunctions.showError(context, errorMessage);
      }
    } catch (e) {
      Navigator.of(context).pop();
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Visibility(
            visible: isallowreceipt && headerid.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.save_as, color: Colors.white),
              onPressed: () {
                if (headerid.isNotEmpty) {
                  confirm(context, headerid);
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppTextFormField(
              labelText: 'Stock Check Id',
              controller: stockcheckController,
              suffixIcon: IconButton(
                onPressed: () {
                  if (stockcheckController.text.isNotEmpty) {
                    setState(() {
                      loadData();
                    });
                  }
                },
                icon: Icon(Icons.search),
              ),
            ),

            Divider(color: AppTheme.accentColor),
            Expanded(
              child:
                  _isLoading
                      ? ShimmerListView(
                        itemCount: 6,
                        itemHeight: 90,
                        verticalSpacing: 2,
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        padding: EdgeInsets.all(0),
                      )
                      : ListView.builder(
                        itemCount: stockchecklist.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(AppFunctions.locator),
                              title: Text(stockchecklist[index].locator),
                              subtitle: Text(
                                'completed ${stockchecklist[index].verifiedcount} of ${stockchecklist[index].totalquantity}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow_rounded),
                                onPressed: () {
                                  navigator(context, index);
                                },
                              ),
                              onLongPress: () {
                                navigator(context, index);
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void navigator(BuildContext context, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StockCheckPalletScreen(
              title: 'Locator Pallets',
              locator: stockchecklist[index].locator,
              stockcheckid: stockcheckController.text,
            ),
      ),
    );

    loadData();
  }
}
