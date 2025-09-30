import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appautocompletebox.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/appdateformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/recieve/api_service_recieve.dart';
import 'package:food_wms/screens/recieve/list_shipment.dart';

class ShipmentFormDialogContent extends StatefulWidget {
  String ponumber;
  String mrrfileno;
  ShipmentFormDialogContent({
    super.key,
    required this.ponumber,
    required this.mrrfileno,
  });

  @override
  ShipmentFormDialogContentState createState() =>
      ShipmentFormDialogContentState();
}

class ShipmentFormDialogContentState extends State<ShipmentFormDialogContent> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController shipmentRefController = TextEditingController();
  final TextEditingController shipmentFilenoController =
      TextEditingController();
  final TextEditingController shipmentModeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  FocusNode shipmentReffocus = FocusNode();
  FocusNode filenofocus = FocusNode();
  FocusNode datefocus = FocusNode();
  FocusNode countryfocus = FocusNode();
  FocusNode shipmentfocus = FocusNode();
  FocusNode buttonfocus = FocusNode();

  List<ShipmentCountryListItem> countrylist = [];
  List<ShipmentModeListItem> shipmentmodelist = [];
  List<String> countrystringlist = [];
  List<String> shipmentmodestringlist = [];

  bool issaving = false;
  String shipmentmodevalue = '';
  String countryvalue = '';

  @override
  void initState() {
    shipmentReffocus.requestFocus();
    DateTime nowDate = DateTime.now();
    super.initState();

    binddropdown();
    issaving = false;
    shipmentmodevalue = '';
    countryvalue = '';
  }

  void binddropdown() async {
    countrylist = await RecieveApiService.getAllcountry();
    shipmentmodelist = await RecieveApiService.getAllshipmentmode();

    countrystringlist = countrylist.map((country) => country.name).toList();
    shipmentmodestringlist =
        shipmentmodelist.map((ship) => ship.description).toList();
  }

  void save() async {
    try {
      if (_formKey.currentState!.validate()) {
        issaving = true;

        String result = await RecieveApiService.shipmentsupdate(
          widget.ponumber,
          shipmentFilenoController.text,
          shipmentmodevalue,
          countryvalue,
          shipmentRefController.text,
          dateController.text,
        );

        issaving = false;
        if (result == 'Success') {
          AppFunctions.showSuccessDialog(context, 'Information Saved.');
          await Future.delayed(Duration(seconds: 1));

          Navigator.of(context).pop();
          Navigator.of(context).pop('Success');
        } else {
          AppFunctions.showError(context, result);
        }
      }
    } catch (e) {
      issaving = false;
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Shipment Details',
                        style: AppTheme.lightTheme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop('Close');
                        },
                        icon: Icon(Icons.close, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Divider(color: AppTheme.accentColor),
              ),

              AppTextFormField(
                controller: shipmentRefController,
                focusnode: shipmentReffocus,
                labelText: 'Shipment Reference',
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please enter a Shipment Reference';
                  }
                  return null;
                },
                onFieldSubmitted: (p0) {
                  filenofocus.requestFocus();
                },
              ),
              AppTextFormField(
                controller: shipmentFilenoController,
                focusnode: filenofocus,
                labelText: 'Shipment File No',
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Please enter a Shipment File No';
                  }
                  return null;
                },
                onFieldSubmitted: (p0) {
                  datefocus.requestFocus();
                },
              ),
              DateInputField(
                initialDate: DateTime.now().subtract(Duration(days: 1)),
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now(),
                controller: dateController,
                focusnode: datefocus,
                label: 'Shipping Date (dd-MMM-yyyy)',
                onsubmit: () {
                  shipmentfocus.requestFocus();
                },
              ),

              AppAutoCompleteField(
                controller: shipmentModeController,
                labelText: 'Shipment Mode',
                suggestionsCallback: (pattern) async {
                  List<String> shipmode =
                      shipmentmodestringlist
                          .where(
                            (mode) => mode.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                          )
                          .toList();
                  return shipmode;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.transform, color: AppTheme.accentColor),
                    title: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
                onSelected: (suggestion) {
                  shipmentModeController.text = suggestion;
                  FocusScope.of(context).unfocus();
                  // _buttonFocusNode.requestFocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Shipment Mode';
                  }

                  List<ShipmentModeListItem> item =
                      shipmentmodelist
                          .where(
                            (x) =>
                                x.description.toLowerCase() ==
                                value.toLowerCase(),
                          )
                          .toList();

                  if (item.isEmpty) {
                    return 'Invalid Shipment Mode selected';
                  } else {
                    shipmentmodevalue = item[0].mode;
                  }
                  return null;
                },
              ),

              AppAutoCompleteField(
                controller: countryController,
                labelText: 'Country',
                suggestionsCallback: (pattern) async {
                  List<String> country =
                      countrystringlist
                          .where(
                            (coun) => coun.toLowerCase().contains(
                              pattern.toLowerCase(),
                            ),
                          )
                          .toList();
                  return country;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.map, color: AppTheme.accentColor),
                    title: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  );
                },
                onSelected: (suggestion) {
                  countryController.text = suggestion;
                  FocusScope.of(context).unfocus();
                  buttonfocus.requestFocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select Country';
                  }

                  List<ShipmentCountryListItem> item =
                      countrylist
                          .where(
                            (x) => x.name.toLowerCase() == value.toLowerCase(),
                          )
                          .toList();

                  if (item.isEmpty) {
                    return 'Invalid country selected';
                  } else {
                    countryvalue = countrylist[0].code;
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  focusNode: buttonfocus,
                  onPressed: () {
                    if (issaving) {
                      return;
                    }
                    save();
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
