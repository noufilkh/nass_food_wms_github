import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appnumericformfield.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';
import 'package:food_wms/screens/recieve/api_service_recieve.dart';
import 'package:food_wms/screens/recieve/list_item_recieve.dart';
import 'package:intl/intl.dart';

class ReceiveScreen extends StatefulWidget {
  final ReceiveListItem item;

  const ReceiveScreen({super.key, required this.item});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _locatorController = TextEditingController();
  final _palletController = TextEditingController();
  final _productionDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _holdQuantityController = TextEditingController();
  final _remarksController = TextEditingController();
  final _serialfromController = TextEditingController();
  final _serialtillController = TextEditingController();
  final _lotnoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String subtitle = '';

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();

    subtitle = 'Item Code : ${widget.item.itemCode}';
    subtitle += '\nItem Description : ${widget.item.itemDescription}';
    subtitle += '\nOrdered Quantity : ${widget.item.orderedquantity}';
    subtitle +=
        '\nLine Id : ${widget.item.lineid} - ${widget.item.linelocationid}';

    if (widget.item.lastexpirydate.isNotEmpty) {
      DateTime? lastExpiryDate = DateTime.tryParse(widget.item.lastexpirydate);

      if (lastExpiryDate != null) {
        _expiryDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(lastExpiryDate);
      }
    }

    if (widget.item.lastproductiondate.isNotEmpty) {
      DateTime? lastProductionDate = DateTime.tryParse(
        widget.item.lastproductiondate,
      );

      if (lastProductionDate != null) {
        _productionDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(lastProductionDate);
      }
    }
  }

  void _clearTextFields() {
    _quantityController.clear();
    _weightController.clear();
    _locatorController.clear();
    _palletController.clear();
    _productionDateController.clear();
    _expiryDateController.clear();
    _holdQuantityController.clear();
    _remarksController.clear();
    _serialfromController.clear();
    _serialtillController.clear();
    _lotnoController.clear();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    String? text,
  ) async {
    DateTime nowDate = DateTime.now();
    DateTime nowdateminusone = nowDate.subtract(Duration(days: 1));
    DateTime nowdateplusone = nowDate.add(Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: text == 'Production' ? nowdateminusone : nowdateplusone,
      firstDate: text == 'Production' ? DateTime(2000) : nowdateplusone,
      lastDate: text == 'Production' ? nowdateminusone : DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd-MMM-yyyy').format(picked);
        //print('Selected date: ${DateFormat('dd-MMM-yyyy').format(picked)}');
      });
    }
  }

  void _saveData() async {
    try {
      if (_formKey.currentState!.validate()) {
        await AppFunctions.showAlertloading(context, 'Please wait..');

        final returndata = await RecieveApiService.recievedItemsInsert(
          SharedPreferencesHelper.loadString(SharedPreferencesHelper.KEY_ORGID),
          widget.item.linelocationid,
          null,
          null,
          _locatorController.text.trim(),
          _quantityController.text,
          _lotnoController.text,
          _expiryDateController.text,
          _serialfromController.text.isEmpty
              ? null
              : _serialfromController.text,
          _serialtillController.text.isEmpty
              ? null
              : _serialtillController.text,
          _remarksController.text.isEmpty ? null : _remarksController.text,
          _palletController.text.trim(),
          _weightController.text.isEmpty ? null : _weightController.text,
          _productionDateController.text,
          _holdQuantityController.text.isEmpty
              ? null
              : _holdQuantityController.text,
          SharedPreferencesHelper.loadString(
            SharedPreferencesHelper.KEY_USERID,
          ),
          null,
        );
        Navigator.of(context).pop();

        if (returndata == 'Success') {
          _clearTextFields();
          AppFunctions.showSuccessDialog(
            context,
            'Information Saved Successfully',
          );

          Navigator.pop(context, true);
          Navigator.pop(context, true);
        } else {
          AppFunctions.showError(context, returndata);
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    const lightGrey = Colors.grey;
    const smallLabelStyle = TextStyle(fontSize: 12, color: lightGrey);
    const divider = Divider(color: AppTheme.accentColor, thickness: 1.0);
    const textFieldPadding = EdgeInsets.only(bottom: 10.0);

    return Scaffold(
      appBar: AppBar(
        title: SelectableText('PO. No : ${widget.item.poNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Padding(padding: textFieldPadding, child: divider),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Max Quantity : ${widget.item.pendingquantity}',
                        style: smallLabelStyle,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: AppNumericFormField(
                      labelText: 'Quantity',
                      controller: _quantityController,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Quantity';
                        }

                        int qunatity = int.tryParse(value) ?? -1;

                        if (qunatity <= 0) {
                          return 'Quantity must be greater than 0';
                        }

                        if (qunatity > widget.item.pendingquantity) {
                          return 'Quantity must be less than or equal to ${widget.item.pendingquantity}';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: AppNumericFormField(
                      labelText: 'Weight',
                      controller: _weightController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }

                        if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Weight must be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              AppTextFormField(
                controller: _locatorController,
                labelText: 'Locator',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Locator';
                  }
                  return null;
                },
              ),
              AppTextFormField(
                labelText: 'Pallet',
                controller: _palletController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pallet';
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: AppFunctions.textfieldbottompadding.bottom,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _productionDateController,
                        decoration: const InputDecoration(
                          labelText: 'Production',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap:
                            () => _selectDate(
                              context,
                              _productionDateController,
                              'Production',
                            ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _expiryDateController,
                        decoration: const InputDecoration(
                          labelText: 'Expiry',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Expiry Date';
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap:
                            () => _selectDate(
                              context,
                              _expiryDateController,
                              'Expiry',
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      labelText: 'Lot No.',
                      controller: _lotnoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Lot No.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: AppNumericFormField(
                      controller: _holdQuantityController,
                      labelText: 'Hold Quantity',
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.item.serialenabled == 'Y',
                child: Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        labelText: 'Serial From',
                        controller: _serialfromController,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: AppTextFormField(
                        labelText: 'Serial Till',
                        controller: _serialtillController,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: textFieldPadding,
                child: TextFormField(
                  controller: _remarksController,
                  decoration: const InputDecoration(labelText: 'Remarks'),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
