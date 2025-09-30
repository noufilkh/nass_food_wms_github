import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appautocompletebox.dart';
import 'package:food_wms/customcontrols/appnumericformfield.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/relocate_items/api_relocate_items.dart';
import 'package:food_wms/screens/search/api_search_item.dart';
import 'package:food_wms/screens/search/search_list_item.dart';

class RelocateItemScreen extends StatefulWidget {
  final String title;

  const RelocateItemScreen({super.key, required this.title});

  @override
  RelocateItemScreenState createState() => RelocateItemScreenState();
}

class RelocateItemScreenState extends State<RelocateItemScreen> {
  final _oldPalletController = TextEditingController();
  final _newPalletController = TextEditingController();
  final _newlocatorController = TextEditingController();
  final _itemController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showqunatity = false;
  bool showweight = false;
  String itemdescription = '';
  List<String> distinctpallets = [];
  List<SearchListItem> itemdetail = [];
  List<String> distinctlocator = [];
  List<String> distinctsubinventory = [];
  String locator = '';
  String subinv = '';

  @override
  void initState() {
    super.initState();
    reset();
  }

  void _saveData() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (distinctpallets
            .where((x) => x == _oldPalletController.text)
            .isEmpty) {
          AppFunctions.showError(context, 'Please select a valid From Pallet');
          return;
        }

        await AppFunctions.showAlertloading(context, 'Please wait..');
        await Future.delayed(Duration(seconds: 1));

        _itemController.text = _itemController.text.trim();
        _newPalletController.text = _newPalletController.text.trim();
        _newlocatorController.text = _newlocatorController.text.trim();
        String actlocator = locator.replaceAll('Locator : ', '').trim();
        String actsubinv = subinv.replaceAll('Sub Inv : ', '').trim();        

        String message = await RelocateItemsApiService.relocateitemupdate(
          _itemController.text,
          _oldPalletController.text,
          actlocator,
          actsubinv,
          _newPalletController.text,
          _newlocatorController.text,
          '',
        );
        Navigator.of(context).pop();
        if (message != 'Success') {
          AppFunctions.showError(context, message);
          return;
        } else {
          AppFunctions.showSuccessDialog(context, "Saved Successfully");
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      AppFunctions.showError(context, e.toString());
    }
  }

  void getitemdetails() async {
    try {
      await AppFunctions.showAlertloading(context, 'Please wait..');

      await Future.delayed(Duration(seconds: 1));

      _itemController.text = _itemController.text.trim();

      itemdetail = await SearchItemApiService.searchitem(
        _itemController.text,
        '',
      );

      Navigator.of(context).pop();

      if (itemdetail.isEmpty) {
        setState(() {
          reset();
        });
      } else {
        setState(() {
          locator = 'Locator : N/A';
          subinv = 'Sub Inv : N/A';
          _oldPalletController.clear();
          itemdescription = itemdetail.first.itemDescription;
          distinctpallets = itemdetail.map((p) => p.pallet).toSet().toList();
        });
      }
    } catch (e) {
      Navigator.of(context).pop();
      setState(() {
        reset();
      });
      AppFunctions.showError(context, e.toString());
    }
  }

  void onpalletchange(String suggestion) {
    _oldPalletController.text = suggestion;
    FocusScope.of(context).unfocus();

    List<SearchListItem> filter =
        itemdetail.where((item) => item.pallet == suggestion).toList();

    distinctlocator = filter.map((p) => p.locator).toSet().toList();
    locator =
        distinctlocator.isNotEmpty
            ? 'Locator : ${distinctlocator.first}'
            : 'No locator found';

    distinctsubinventory = filter.map((p) => p.subinventory).toSet().toList();
    subinv =
        distinctsubinventory.isNotEmpty
            ? 'Sub Inv : ${distinctsubinventory.first}'
            : 'No Sub inventory found';
  }

  void reset() {
    itemdescription = 'No item Selected';
    locator = 'Locator : N/A';
    subinv = 'Sub Inv : N/A';
    _oldPalletController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.save, color: Colors.white),
            onPressed: _saveData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Divider(color: AppTheme.accentColor),
              ),

              AppTextFormField(
                labelText: 'Item Code',
                textFieldPadding: EdgeInsets.only(bottom: 0),
                onFieldSubmitted: (p0) {
                  getitemdetails();
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    getitemdetails();
                  },
                  icon: Icon(Icons.search),
                ),

                controller: _itemController,
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'Item Code');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 8.0, top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        itemdescription,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),

              AppAutoCompleteField(
                controller: _oldPalletController,
                textFieldPadding: EdgeInsets.only(bottom: 0),
                labelText: 'From Pallet',
                suggestionsCallback: (pattern) async {
                  List<String> pallets =
                      distinctpallets
                          .where(
                            (pallet) => pallet.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                          )
                          .toList();
                  return pallets;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.pallet, color: AppTheme.accentColor),
                    title: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
                onSelected: (suggestion) {
                  onpalletchange(suggestion);
                  // FocusScope.of(context).unfocus();
                  // _buttonFocusNode.requestFocus();
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'From Pallet');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 8.0, top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        locator,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subinv,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),

              AppTextFormField(
                labelText: 'To Pallet',
                controller: _newPalletController,
                initialValue: '',
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'To Pallet');
                },
              ),
              AppTextFormField(
                labelText: 'To Locator',
                controller: _newlocatorController,
                initialValue: '',
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'To Locator');
                },
              ),
              AppNumericFormField(
                controller: _quantityController,
                labelText: 'Quantity',
                validator: (value) {
                  return AppFunctions.validatePositiveNumber(value, 'Quantity');
                },
              ),

              // AppTextFormField(
              //   labelText: 'Remarks',
              //   controller: _remarksController,
              //   initialValue: '',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
