import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';

class AppNumericFormField extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool? enable;

  const AppNumericFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    this.validator,
    required this.controller,
    this.onChanged,
    this.enable,
  });

  @override
  AppNumericFormFieldState createState() => AppNumericFormFieldState();
}

class AppNumericFormFieldState extends State<AppNumericFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppFunctions.textfieldbottompadding,
      child: TextFormField(
        enabled: widget.enable,
        controller: widget.controller,
        decoration: InputDecoration(labelText: widget.labelText),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: Theme.of(context).textTheme.titleMedium,
        validator: widget.validator,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
      ),
    );
  }

  String getValue() {
    return widget.controller.text;
  }
}
