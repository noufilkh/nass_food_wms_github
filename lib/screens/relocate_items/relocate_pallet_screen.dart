import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/apptextformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/relocate_items/api_relocate_items.dart';

class RelocatePalletScreen extends StatefulWidget {
  final String title;

  const RelocatePalletScreen({super.key, required this.title});

  @override
  RelocatePalletScreenState createState() => RelocatePalletScreenState();
}

class RelocatePalletScreenState extends State<RelocatePalletScreen> {
  final _fromPalletController = TextEditingController();
  final _fromlocatorController = TextEditingController();
  final _tolocatorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveData() async {
    try {
      if (_formKey.currentState!.validate()) {
        AppFunctions.showAlertloading(context, 'Please wait..');

        _fromPalletController.text = _fromPalletController.text.trim();
        _fromlocatorController.text = _fromlocatorController.text.trim();
        _tolocatorController.text = _tolocatorController.text.trim();

        String message = await RelocateItemsApiService.relocatepalletupdate(
          _fromPalletController.text,
          _fromlocatorController.text,
          _tolocatorController.text,
        );

        Navigator.of(context).pop();

        if (message != 'Success') {
          AppFunctions.showError(context, message);
          return;
        } else {
          AppFunctions.showSuccessDialog(
            context,
            "Pallet Relocate Successfully",
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop();
      AppFunctions.showError(context, e.toString());
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Relocate Pallet from one locator to other'),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Divider(color: AppTheme.accentColor),
              ),
              AppTextFormField(
                labelText: 'Pallet',
                initialValue: '',
                onChanged: (returnvalue) {
                  _fromPalletController.text = returnvalue;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'Pallet');
                },
              ),
              AppTextFormField(
                labelText: 'From Locator',
                initialValue: '',
                onChanged: (returnvalue) {
                  _fromlocatorController.text = returnvalue;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'From Locator');
                },
              ),
              AppTextFormField(
                labelText: 'To Locator',
                initialValue: '',
                onChanged: (returnvalue) {
                  _tolocatorController.text = returnvalue;
                },
                validator: (value) {
                  return AppFunctions.validateNonEmpty(value, 'To Locator');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
