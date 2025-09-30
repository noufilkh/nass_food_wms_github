import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';

import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/salesreturn/api_service_return.dart';
import 'package:food_wms/screens/salesreturn/salesreturnlist.dart';

class SalesReturnScreen extends StatefulWidget {
  final String title;
  final String? stockcheckid;
  final String? pallet;
  final String? locator;

  const SalesReturnScreen({
    super.key,
    required this.title,
    this.stockcheckid,
    this.locator,
    this.pallet,
  });

  @override
  SalesReturnScreenState createState() => SalesReturnScreenState();
}

class SalesReturnScreenState extends State<SalesReturnScreen> {
  List<SalessReturnlist> _itemList = List.empty();
  TextEditingController puchasecontroller = TextEditingController();
  TextEditingController reasoncontroller = TextEditingController();
  TextEditingController enteredquantity = TextEditingController();
  bool _isLoading = false;
  bool isallowreceipt = false;
  String headerid = '';

  @override
  void initState() {
    final allowreceipt = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERALLOWRECIEPTID,
    );
    isallowreceipt = allowreceipt == 'Y' ? true : false;

    super.initState();
  }

  @override
  void dispose() {
    for (SalessReturnlist controller in _itemList) {
      controller.enteredquantity.dispose();
    }
    super.dispose();
  }

  void bindlist() async {
    try {
      _isLoading = true;
      await Future.delayed(Duration(seconds: 1)); // Simulate loading delay
      List<SalessReturnlist> orgitemList =
          await SalesReturnApiService.returnByOrderNO(puchasecontroller.text);

      headerid = orgitemList.isNotEmpty ? orgitemList[0].headerid : '';

      setState(() {
        _itemList = orgitemList;
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
      AppFunctions.showError(context, e.toString());
    }
  }

  void save(
    BuildContext context,
    String headerid,
    String lineid,
    int entered,
    int ordered,
  ) async {
    try {
      if (entered > ordered) {
        AppFunctions.showError(
          context,
          'Return quantity cannot be greater than ordered quantity',
        );
        return;
      }

      String message = await SalesReturnApiService.salesreturnupdate(
        headerid,
        lineid,
        entered.toString(),
      );

      if (message != 'Success') {
        AppFunctions.showError(context, message);
        return;
      } else {
        AppFunctions.showSuccessDialog(context, "Saved Successfully");
      }
    } catch (e) {
      AppFunctions.showError(context, 'An error occurred: $e');
    }
  }

  void confirm(BuildContext context, String headerid, String reason) async {
    if (reason.isEmpty) {
      AppFunctions.showError(
        context,
        'Please enter a reason for the sales return',
      );
      return;
    }
    try {
      String message = await SalesReturnApiService.salesreturnconfirm(
        headerid,
        reason,
      );

      if (message != 'Success') {
        AppFunctions.showError(context, message);
        return;
      } else {
        AppFunctions.showSuccessDialog(context, "Saved Successfully");
      }
    } catch (e) {
      AppFunctions.showError(context, 'An error occurred: $e');
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
                confirm(context, headerid, reasoncontroller.text);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppTextFormField(
              labelText: 'Order No.',
              controller: puchasecontroller,
              validator: (value) {
                return AppFunctions.validateNonEmpty(value, 'Order No.');
              },
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    headerid = '';
                  });
                }
              },
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (puchasecontroller.text.isEmpty) {
                    setState(() {
                      _itemList = List.empty();
                      headerid = '';
                    });
                  } else {
                    setState(() {
                      bindlist();
                    });
                  }
                },
              ),
            ),
            Visibility(
              visible: isallowreceipt,
              child: AppTextFormField(
                labelText: 'Reason for Sales Return',
                onChanged: (returnvalue) {
                  reasoncontroller.text = returnvalue;
                },
              ),
            ),
            Divider(color: AppTheme.accentColor),
            SizedBox(height: 2),
            Expanded(
              child:
                  _isLoading
                      ? ShimmerListView(
                        itemCount: 5,
                        itemHeight: 120,
                        verticalSpacing: 2,
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        padding: EdgeInsets.all(0),
                      )
                      : ListView.builder(
                        itemCount: _itemList.length,
                        itemBuilder: (context, index) {
                          final item = _itemList[index];
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
                                          'Ordered Quantity : ${item.primaryquantity}\nUOM : ${item.primaryuom}',
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
                                          controller:
                                              _itemList[index].enteredquantity,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),

                                      Visibility(
                                        visible: !isallowreceipt,
                                        child: IconButton(
                                          onPressed: () {
                                            if (_itemList[index]
                                                .enteredquantity
                                                .text
                                                .isEmpty) {
                                              return;
                                            }

                                            int? entered = int.tryParse(
                                              _itemList[index]
                                                  .enteredquantity
                                                  .text,
                                            );

                                            int? ordered = int.tryParse(
                                              _itemList[index].primaryquantity,
                                            );

                                            if (entered != null &&
                                                ordered != null &&
                                                entered > 0 &&
                                                ordered > 0) {
                                              save(
                                                context,
                                                _itemList[index].headerid,
                                                _itemList[index].lineid,
                                                entered,
                                                ordered,
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.save,
                                            color: AppTheme.gridsavebuttoncolor,
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
