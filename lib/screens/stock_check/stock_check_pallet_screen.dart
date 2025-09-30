
import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/stock_check/api_sotck_check.dart';
import 'package:food_wms/screens/stock_check/stock_check_screen.dart';
import 'package:food_wms/screens/stock_check/stockchecklist.dart';

class StockCheckPalletScreen extends StatefulWidget {
  final String title;
  final String locator;
  final String stockcheckid;

  const StockCheckPalletScreen({
    super.key,
    required this.title,
    required this.locator,
    required this.stockcheckid,
  });

  @override
  State<StockCheckPalletScreen> createState() => _StockCheckPalletScreenState();
}

class _StockCheckPalletScreenState extends State<StockCheckPalletScreen> {
  List<StockcheckPalletlist> stockcheckpalletlist = List.empty(growable: true);
  List<StockcheckPalletlist> orgstockcheckpalletlist = List.empty(
    growable: true,
  );
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      orgstockcheckpalletlist =
          await StockCheckApiService.getpalletbystockcheckno(
            widget.stockcheckid,
            widget.locator,
          );

      setState(() {
        _isLoading = false;
        stockcheckpalletlist =
            orgstockcheckpalletlist.isEmpty
                ? List.empty(growable: true)
                : orgstockcheckpalletlist;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppFunctions.showError(context, e.toString());
    }
  }

  void navigator(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => StockCheckScreen(
              pallet: stockcheckpalletlist[index].pallet,
              locator: widget.locator,
              stockcheckid: widget.stockcheckid,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title} - ${widget.stockcheckid}')),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Locator : ${widget.locator}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Divider(color: AppTheme.accentColor),
            ),

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
                        itemCount: stockcheckpalletlist.length,
                        itemBuilder: (context, index) {
                          final pallet = stockcheckpalletlist[index].pallet;
                          return Card(
                            child: ListTile(
                              leading: Icon(AppFunctions.pallet),
                              title: Text(
                                'Pallet : ${pallet.isNotEmpty ? pallet : 'N/A'}',
                              ),
                              subtitle: Text(
                                'Total Item count ${stockcheckpalletlist[index].itemcount}',
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
}
