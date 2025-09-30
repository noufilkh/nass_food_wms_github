import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/delivery/api_service_delivery.dart';
import 'package:food_wms/screens/delivery/list_item_delivery_pallet_items.dart';

class DeliveryPalletSearchScreen extends StatefulWidget {
  final String deliveryNo;
  final String locator;
  final int locatorid;

  const DeliveryPalletSearchScreen({
    super.key,
    required this.deliveryNo,
    required this.locator,
    required this.locatorid,
  });

  @override
  State<DeliveryPalletSearchScreen> createState() =>
      _DeliveryPalletSearchScreenState();
}

class _DeliveryPalletSearchScreenState
    extends State<DeliveryPalletSearchScreen> {
  final TextEditingController _palletController = TextEditingController();
  List<DeliveryPalletItemsListItem> _itemDetails = [];
  List<DeliveryPalletItemsListItem> _orgItemDetails = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    loaddata();
  }

  Future<void> loaddata() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _itemDetails = await DeliveryApiService.palletitemsByDeliveryNOAndLocator(
        widget.deliveryNo,
        widget.locatorid,
      );

      _orgItemDetails = _itemDetails;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  void _openDeliveryScreen(DeliveryPalletItemsListItem listitem) async {
    try {
      await AppRoutes.redirectdeliveryScreen(
        context,
        widget.deliveryNo,
        widget.locator,
        listitem,
      );

      setState(() {
        loaddata();
      });
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  void _searchPallet(String pallet) {
    if (pallet.isEmpty) {
      setState(() {
        _itemDetails = _orgItemDetails;
      });
    } else {
      setState(() {
        _itemDetails =
            _orgItemDetails
                .where(
                  (item) =>
                      item.pallet.toLowerCase().contains(pallet.toLowerCase()),
                )
                .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.deliveryNo} - ${widget.locator}')),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 0),
        child: Column(
          children: [
            AppTextFormField(
              labelText: 'Search Pallet',
              controller: _palletController,
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _itemDetails = _orgItemDetails;
                  });
                }
              },
              suffixIcon: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _searchPallet(_palletController.text);
                },
              ),
            ),
            Divider(color: AppTheme.accentColor),
            SizedBox(height: 5),
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
                        itemCount: _itemDetails.length,
                        itemBuilder: (context, index) {
                          final pallet = _itemDetails[index].pallet;
                          final item =
                              '${_itemDetails[index].itemcode} - ${_itemDetails[index].itemdescription}';
                          final quantity = _itemDetails[index].orderedquantity;
                          final weight = _itemDetails[index].netweight;
                          final uom = _itemDetails[index].orderedquantityuom;
                          final entquantity =
                              _itemDetails[index].enteredquantity;
                          final entweight = _itemDetails[index].enteredweight;

                          return Card(
                            child: ListTile(
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(children: [Text(pallet)]),
                                  Row(children: [Expanded(child: Text(item))]),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Quantity : $quantity',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          children: [
                                            Text(
                                              'UOM : $uom',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Weight : $weight',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Entered Quantity : $entquantity',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),

                                        Column(
                                          children: [
                                            Text(
                                              'Entered Weight : $entweight',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                padding: EdgeInsets.only(right: 0),
                                icon: const Icon(Icons.play_arrow_rounded),
                                onPressed: () {
                                  _openDeliveryScreen(_itemDetails[index]);
                                },
                              ),
                              onLongPress: () {
                                _openDeliveryScreen(_itemDetails[index]);
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
