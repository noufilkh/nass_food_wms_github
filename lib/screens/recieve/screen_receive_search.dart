import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/recieve/api_service_recieve.dart';
import 'package:food_wms/screens/recieve/list_item_recieve.dart';
import 'package:food_wms/screens/recieve/list_shipment.dart';
import 'package:food_wms/screens/recieve/shipment_screen.dart';

class ReceiveSearchScreen extends StatefulWidget {
  final String title;
  const ReceiveSearchScreen({super.key, required this.title});

  @override
  State<ReceiveSearchScreen> createState() => _ReceiveSearchScreenState();
}

class _ReceiveSearchScreenState extends State<ReceiveSearchScreen> {
  final TextEditingController _poNumberController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  List<ReceiveListItem> _items = [];
  List<ReceiveListItem> _orgitems = [];
  String _supplierName = "Suppliers"; // Example supplier name

  bool _isLoading = false;
  bool isallowreceipt = false;
  String headerid = '';

  @override
  void initState() {
    final allowreceipt = SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_USERALLOWRECIEPTID,
    );
    isallowreceipt = allowreceipt == 'Y' ? true : false;
    loadData();
    super.initState();
  }

  // Function to filter the list by item code
  void _filterItems(String itemCode) {
    itemCode = itemCode.trim();
    setState(() {
      if (itemCode.isEmpty) {
        _items = _orgitems;
      } else {
        _items =
            _items
                .where(
                  (item) => item.itemCode.toLowerCase().contains(
                    itemCode.toLowerCase(),
                  ),
                )
                .toList();
      }
    });
  }

  Future<void> loadData() async {
    try {
      if (_poNumberController.text.isEmpty) {
        return;
      }

      setState(() {
        _itemCodeController.clear();
        _isLoading = true;
      });

      _poNumberController.text = _poNumberController.text.trim();

      _items = await RecieveApiService.receivedbyPO(_poNumberController.text);
      _orgitems = _items;

      if (_items.isNotEmpty) {
        _supplierName = _items[0].supliername;
        headerid = _items[0].lineid;
      } else {
        resetfield();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  resetfield() {
    setState(() {
      _items = List.empty();
      _orgitems = List.empty();
      _supplierName = 'N/A';
      headerid = '';
    });
  }

  confirmPoNumber() async {
    try {
      await AppFunctions.showAlertloading(context, 'Please wait..');

      _poNumberController.text = _poNumberController.text.trim();

      final returndata = await ApiService.recievedItemsConfirmation(
        SharedPreferencesHelper.loadString(SharedPreferencesHelper.KEY_ORGID),
        _poNumberController.text,
        SharedPreferencesHelper.loadString(SharedPreferencesHelper.KEY_USERID),
      );
      Navigator.of(context).pop();

      if (returndata['status'] != null) {
        if (returndata['status'] == 'Ok') {
          _poNumberController.text = "";
          setState(() {
            _items = List.empty();
            _orgitems = List.empty();
            _supplierName = '';
          });
          AppFunctions.showSuccessDialog(
            context,
            'PO Receipt Created Successfully',
          );
        } else {
          List<dynamic> errorlist = returndata['WMS Insert Serial'];

          if (errorlist.isNotEmpty) {
            List<dynamic> innerList = errorlist[0];
            if (innerList.isNotEmpty) {
              String recordMessage = innerList[0];
              AppFunctions.showError(context, recordMessage);
            }
          }
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      AppFunctions.showError(context, e.toString());
    }
  }

  Future<ShipmentListItem> getShipment() async {
    return await RecieveApiService.getshipment(_poNumberController.text);
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
              onPressed: () {
                confirmPoNumber();
              },
              icon: Icon(Icons.save_as),
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
              labelText: 'Purchase Order No',
              controller: _poNumberController,
              onChanged: (value) {
                if (value.isEmpty) {
                  resetfield();
                }
              },
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  if (_poNumberController.text.isEmpty) {
                    resetfield();
                  } else {
                    ShipmentListItem item = await getShipment();

                    if (item.ponumber.isEmpty) {
                      AppFunctions.showError(context, 'Po Number not found');
                      return;
                    }
                    if (item.country.isEmpty ||
                        item.mode.isEmpty ||
                        item.date.isEmpty) {
                      resetfield();
                      String returnmessage = await showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: EdgeInsets.symmetric(horizontal: 0),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 40,
                              ),
                              child: ShipmentFormDialogContent(
                                ponumber: item.ponumber,
                                mrrfileno: item.mrrfileno,
                              ),
                            ),
                          );
                        },
                      );
                      if (returnmessage == 'Success') {
                        loadData();
                      }
                    } else {
                      loadData();
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  }
                },
              ),
            ),

            AppTextFormField(
              controller: _itemCodeController,
              labelText: 'Item Code',
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _filterItems(_itemCodeController.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _items = _orgitems;
                  });
                }
              },
            ),

            Divider(color: AppTheme.accentColor),
            const SizedBox(height: 2.0),
            Flexible(
              child: Text(
                'Supplier Name: $_supplierName',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8.0),
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
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: SelectableText(
                                '${item.itemCode}\n${item.itemDescription}',
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(
                                'Ordered Quantity: ${item.orderedquantity}\nEntered  Quantity: ${item.enteredquantity}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              leading: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  await AppRoutes.redirectenteredSearchrecieveitem(
                                    context,
                                    item,
                                  );
                                  loadData();
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.keyboard_arrow_right),
                                onPressed: () async {
                                  await AppRoutes.redirectrecieveitems(
                                    context,
                                    item,
                                  );
                                  loadData();
                                },
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
