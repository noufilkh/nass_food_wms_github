import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/stock_check/api_sotck_check.dart';
import 'package:food_wms/screens/stock_check/stockchecklist.dart';

class StockCheckScreen extends StatefulWidget {
  final String stockcheckid;
  final String pallet;
  final String locator;

  const StockCheckScreen({
    super.key,
    required this.stockcheckid,
    required this.locator,
    required this.pallet,
  });

  @override
  StockCheckScreenState createState() => StockCheckScreenState();
}

class StockCheckScreenState extends State<StockCheckScreen> {
  List<Stockcheckitemslist> itemList = List.empty(growable: true);
  List<Stockcheckitemslist> orgitemList = List.empty(growable: true);
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
      orgitemList = await StockCheckApiService.getpalletitemsbystockcheckno(
        widget.stockcheckid,
        widget.locator,
        widget.pallet,
      );

      setState(() {
        _isLoading = false;
        itemList =
            orgitemList.isEmpty ? List.empty(growable: true) : orgitemList;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppFunctions.showError(context, e.toString());
    }
  }

  void save(BuildContext context) async {
    try {
      await AppFunctions.showAlertloading(context, 'Please wait..');

      await Future.delayed(Duration(seconds: 1));

      List<Stockcheckupdatelist> dataToSend = List.empty(growable: true);

      for (var element in itemList) {
        if (element.isquantityentered) {
          double enteredquantity =
              double.tryParse(element.enteredquantity.text) ?? 0.0;

          double onhandquantity =
              double.tryParse(element.onhandquantity) ?? 0.0;

          if (enteredquantity > onhandquantity) {
            Navigator.of(context).pop();
            dataToSend = List.empty(growable: true);
            AppFunctions.showError(
              context,
              'Entered quantity cannot be greater than On Hand Quantity for Item: ${element.itemcode}',
            );

            return;
          }

          dataToSend.add(
            Stockcheckupdatelist(
              headerid: element.headerid,
              lineid: element.lineid,
              verifiedquantity: element.enteredquantity.text,
            ),
          );
        }
      }

      if (dataToSend.isNotEmpty) {
        List<StockcheckupdateErrorlist> error =
            await StockCheckApiService.stockcheckupdate(dataToSend);

        Navigator.of(context).pop();

        if (error.isEmpty) {
          AppFunctions.showSuccessDialog(
            context,
            'Stock Check Updated Successfully',
          );
        } else {
          String errorMessage = '';
          for (var err in error) {
            String itemCode =
                itemList
                    .firstWhere((item) => item.lineid == err.lineid)
                    .itemcode;

            errorMessage += 'Item Code: $itemCode,\nMessage: ${err.message}\n';
          }

          AppFunctions.showError(context, errorMessage);
        }
      } else {
        Navigator.of(context).pop();
        AppFunctions.showError(context, 'No Data to Save');
      }
    } catch (e) {
      Navigator.of(context).pop();
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  void dispose() {
    for (Stockcheckitemslist controller in itemList) {
      controller.enteredquantity.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              return save(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Stock Check Id : ${widget.stockcheckid}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'Locator : ${widget.locator}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'Pallet : ${widget.pallet}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Divider(color: AppTheme.accentColor),
            SizedBox(height: 10),
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
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          final item = itemList[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemcode,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    item.itemdescription,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Quantity: ${item.onhandquantity}\nUOM ${item.primaryuom}',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.labelMedium,
                                        ),
                                      ),

                                      SizedBox(
                                        width: 120,
                                        height: 35,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            itemList[index].isquantityentered =
                                                true;
                                          },
                                          controller:
                                              itemList[index].enteredquantity,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(fontSize: 12),

                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            focusColor: Colors.white,
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
