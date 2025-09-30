import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/recieve/api_service_recieve.dart';
import 'package:food_wms/screens/recieve/list_item_recieve_entered.dart';
import 'package:food_wms/screens/recieve/list_item_recieve.dart';

class ReceiveEnteredSearchScreen extends StatefulWidget {
  final String title;
  final ReceiveListItem item;

  const ReceiveEnteredSearchScreen({
    super.key,
    required this.title,
    required this.item,
  });

  @override
  State<ReceiveEnteredSearchScreen> createState() =>
      _ReceiveEnteredSearchScreenState();
}

class _ReceiveEnteredSearchScreenState
    extends State<ReceiveEnteredSearchScreen> {
  List<ReceiveEnteredListItem> _items = [];

  bool _isLoading = false;

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

      _items = await RecieveApiService.receivedEnteredbyPO(
        widget.item.poNumber,
        widget.item.itemCode,
      );

      if (_items.isNotEmpty) {}

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(color: AppTheme.accentColor, thickness: 1.0);
    const textFieldPadding = EdgeInsets.only(bottom: 10.0);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} - ${widget.item.poNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              loadData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 14, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.itemCode,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.itemDescription,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Line Id : ${widget.item.lineid} - ${widget.item.linelocationid}',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Ordered Qantity : ${widget.item.orderedquantity}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Entered Qantity : ${widget.item.enteredquantity}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
            Padding(padding: textFieldPadding, child: divider),
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
                            margin: const EdgeInsets.only(
                              bottom: 4.0,
                              top: 4.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 0.0,
                                    right: 6.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          await AppRoutes.redirectenteredrecieveitem(
                                            context,
                                            item,
                                            widget.item.enteredquantity,
                                            widget.item.orderedquantity,
                                          );

                                          loadData();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3.0,
                                    top: 0.0,
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quantity : ${item.recievedquantity}',
                                      ),
                                      Text('Weight : ${item.receivedweight}'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3.0,
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Locator : ${item.locator}'),
                                      Text('Pallet : ${item.pallet}'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 3.0,
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Prod : ${item.productiondate}'),
                                      Text('Expriy : ${item.expirydate}'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                    left: 16.0,
                                    right: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Lot No : ${item.lotnumber}'),
                                      Text(
                                        'Hold Quantity : ${item.holdquantity}',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
