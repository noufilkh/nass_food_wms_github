import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appdatabasehelper.dart';
import 'package:food_wms/customcontrols/apphttprequest.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/search/itemmaster.dart';
import 'package:food_wms/screens/search/search_list_item.dart';

class SearchItemScreen extends StatefulWidget {
  final String title;
  const SearchItemScreen({super.key, required this.title});

  @override
  State<SearchItemScreen> createState() => _SearchItemScreenState();
}

class _SearchItemScreenState extends State<SearchItemScreen> {
  List<SearchListItem> _items = [];
  final _itemsController = TextEditingController();
  final _locatorController = TextEditingController();
  FocusNode _buttonFocusNode = FocusNode();
  bool _isLoading = false;
  String loadingtext = 'Please wait...';

  Future<void> loadData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1)); // Simulate loading delay
      //_items = _generateRandomItems(count);
      _locatorController.text = _locatorController.text.trim();
      _itemsController.text = _itemsController.text.trim();

      final locator = _locatorController.text;
      final itemCode = _itemsController.text;

      if (itemCode.isEmpty && locator.isEmpty) {
        _items = List.empty();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      _items = await ApiService.searchItems(itemCode, locator, '');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AppFunctions.showError(context, e.toString());
    }
  }

  void refreshdata() async {
    try {
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
                    Expanded(
                      flex: 1,
                      child: Column(children: [Text(loadingtext)]),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      List<Map<String, dynamic>> allitems =
          await DatabaseHelper().getAllItems();

      final items = await ApiService.getItemsMaster();
      List<dynamic> listitems = items['ItemMaster'];

      List<ItemMasterList> itemlist =
          listitems.map((data) => ItemMasterList.fromJson(data)).toList();

      int itemcount = listitems.length;
      int start = 1;

      for (var item in itemlist) {
        if (allitems.where((x) => x.containsValue(item.itemCode)).isEmpty) {
          setState(() {
            loadingtext = "Downloading item $start of $itemcount";
          });

          try {
            await DatabaseHelper().insertItem({
              DatabaseHelper.itemCode: item.itemCode,
              DatabaseHelper.itemDescription:
                  '${item.itemCode} - ${item.itemDescription}',
            });
          } catch (e) {
            //print("Error :  $e");
          }
        }
        start = start + 1;
      }
      await Future.delayed(const Duration(seconds: 1));
      Navigator.of(context).pop();
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.refresh),
          //   onPressed: () {
          //     refreshdata();
          //   },
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AppTextFormField(
              labelText: 'Locator',
              controller: _locatorController,
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
                _buttonFocusNode.requestFocus();
              },
            ),
            AppTextFormField(
              labelText: 'Item Code',
              controller: _itemsController,
              onFieldSubmitted: (value) {
                FocusScope.of(context).unfocus();
                _buttonFocusNode.requestFocus();
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                focusNode: _buttonFocusNode,
                onPressed: () {
                  setState(() {
                    loadData();
                  });
                },
                child: Text('Search'),
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
                              subtitle: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Locator: ${item.locator}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Pallet: ${item.pallet}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Quantity : ${!item.itemDescription.contains("Kilograms") ? item.quantity : 0}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'UOM: ${item.uom}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Expiry : ${item.expiryDate}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Lot No : ${item.lotno}',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              leading: Icon(Icons.chevron_right),
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
