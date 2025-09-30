import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appautocompletebox.dart';
import 'package:food_wms/customcontrols/appnumericformfield.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';

class SplitPalletScreen extends StatefulWidget {
  final String title;

  const SplitPalletScreen({super.key, required this.title});

  @override
  SplitPalletScreenState createState() => SplitPalletScreenState();
}

class SplitPalletScreenState extends State<SplitPalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _palletFromController = TextEditingController();
  final _palletToController = TextEditingController();
  final _locatorToController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _remarksController = TextEditingController();
  final _itemsController = TextEditingController();

  @override
  void dispose() {
    _palletFromController.dispose();
    _palletToController.dispose();
    _locatorToController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      AppFunctions.showAlertloading(context, 'Please wait..');
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppTextFormField(
                labelText: 'From Pallet',
                initialValue: '',
                onChanged: (returnvalue) {
                  _palletFromController.text = returnvalue;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'From Pallet');
                },
              ),

              AppAutoCompleteField(
                controller: _itemsController,
                labelText: 'Items',
                suggestionsCallback: (pattern) async {
                  return await AppFunctions.getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    leading: Icon(Icons.food_bank, color: AppTheme.accentColor),
                    title: Text(
                      suggestion,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
                onSelected: (suggestion) {
                  _itemsController.text = suggestion;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'Item');
                },
              ),

              AppTextFormField(
                labelText: 'To Pallet',
                initialValue: '',
                onChanged: (returnvalue) {
                  _palletToController.text = returnvalue;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'To Pallet');
                },
              ),
              AppTextFormField(
                labelText: 'To Locator',
                initialValue: '',
                onChanged: (returnvalue) {
                  _locatorToController.text = returnvalue;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'To Locator');
                },
              ),
              AppNumericFormField(
                labelText: 'Quantity',
                controller: _quantityController,
                validator: (value) {
                  return AppFunctions.validatePositiveNumber(value, 'Quantity');
                },
              ),
              AppNumericFormField(
                controller: _weightController,
                labelText: 'Weight',
                validator: (value) {
                  return AppFunctions.validatePositiveNumber(value, 'Weight');
                },
              ),
              AppTextFormField(
                labelText: 'Remarks',
                onChanged: (returnvalue) {
                  _remarksController.text = returnvalue;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
