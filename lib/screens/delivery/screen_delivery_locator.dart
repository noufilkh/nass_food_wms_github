import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/delivery/api_service_delivery.dart';
import 'package:food_wms/screens/delivery/list_item_delivery_locator.dart';

class DeliveryLocatorSearchScreen extends StatefulWidget {
  final String title;
  const DeliveryLocatorSearchScreen({super.key, required this.title});

  @override
  DeliveryLocatorSearchScreenState createState() =>
      DeliveryLocatorSearchScreenState();
}

class DeliveryLocatorSearchScreenState
    extends State<DeliveryLocatorSearchScreen> {
  final TextEditingController _deliveryNoController = TextEditingController();
  List<DeliveryLocatorListItem> _deliveryNumbers = [];
  bool _isLoading = false;
  bool showconfirm = false;

  Future<void> _searchDeliveries() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _deliveryNoController.text = _deliveryNoController.text.trim();
      _deliveryNumbers = await DeliveryApiService.locatorByDeliveryNO(
        _deliveryNoController.text,
      );

      setState(() {
        showconfirm = (_deliveryNumbers.isNotEmpty);
        _isLoading = false;
      });
    } catch (e) {
      showconfirm = false;
      AppFunctions.showError(context, e.toString());
    }
  }

  void _openDeliveryLocatorScreen(String locatorNo, int locatorid) {    
    if (locatorid == 0) {
      AppFunctions.showError(context, 'Invalid Locator Id');
      return;
    }

    try {
      AppRoutes.redirectdeliverypalletitems(
        context,
        _deliveryNoController.text,
        locatorNo,
        locatorid,
      );
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  confirm() async {
    try {
      AppFunctions.showAlertloading(context, 'Please wait..');
      _deliveryNoController.text = _deliveryNoController.text.trim();
      String message = await DeliveryApiService.deliveryconfirmation(
        _deliveryNoController.text,
      );
      
      if (message == "Success") {
        Navigator.pop(context);
        AppFunctions.showSuccessDialog(
          context,
          'Delivery No Confirmed Successfully',
        );
      } else {
        Navigator.pop(context);
        AppFunctions.showError(context, message);
      }
    } catch (e) {
      Navigator.pop(context);
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
            visible: showconfirm,
            child: IconButton(
              icon: Icon(Icons.save_as),
              onPressed: () {
                if (_deliveryNoController.text.isEmpty) {
                  return;
                } else {
                  confirm();
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 10, right: 10, bottom: 0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            AppTextFormField(
              labelText: 'Delivery No.',
              controller: _deliveryNoController,
              onChanged: (value) {
                setState(() {
                  _deliveryNumbers = [];
                });
                if (value.isEmpty) {
                  setState(() {
                    showconfirm = false;
                  });
                }
              },
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (_deliveryNoController.text.isEmpty) {
                    setState(() {
                      _deliveryNumbers = List.empty();
                    });
                  } else {
                    _searchDeliveries();
                  }
                },
              ),
            ),
            Divider(color: AppTheme.accentColor, thickness: 1.0),
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
                        itemCount: _deliveryNumbers.length,
                        itemBuilder: (context, index) {
                          final locator = _deliveryNumbers[index].locator;
                          final locatorid =
                              int.tryParse(_deliveryNumbers[index].locatorid) ??
                              0;
                          return Card(
                            child: ListTile(
                              title: Text(locator),
                              leading: Icon(AppFunctions.locator),
                              trailing: IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed:
                                    () => _openDeliveryLocatorScreen(
                                      locator,
                                      locatorid,
                                    ),
                              ),
                              onLongPress: () {
                                _openDeliveryLocatorScreen(locator, locatorid);
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
