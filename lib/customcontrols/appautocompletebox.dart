import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';

class AppAutoCompleteField extends StatefulWidget {
  final String labelText;
  final FutureOr<List<String>> Function(String) suggestionsCallback;
  final ValueChanged<String>? onSelected;
  final Widget Function(BuildContext, String) itemBuilder;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? textFieldPadding;

  const AppAutoCompleteField({
    super.key,
    required this.labelText,
    required this.suggestionsCallback,
    required this.onSelected,
    required this.itemBuilder,
    required this.controller,
    this.validator,
    this.textFieldPadding,
  });

  @override
  AppAutoCompleteFieldState createState() => AppAutoCompleteFieldState();
}

class AppAutoCompleteFieldState extends State<AppAutoCompleteField> {
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
      padding:
          (widget.textFieldPadding == null)
              ? AppFunctions.textfieldbottompadding
              : widget.textFieldPadding ?? EdgeInsets.only(bottom: 8.0),
      child: TypeAheadField<String>(
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: widget.labelText,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            style: Theme.of(context).textTheme.titleMedium,
            validator: widget.validator,

            onTap: () {
              if (widget.controller.text.isNotEmpty) {
                widget.controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: widget.controller.text.length,
                );
              }
            },
          );
        },
        hideOnUnfocus: true,
        showOnFocus: true,
        itemSeparatorBuilder: (context, index) {
          return Divider(color: Theme.of(context).hintColor);
        },
        // decorationBuilder:
        //     (context, child) =>
        //         DecoratedBox(decoration: BoxDecoration(color: Colors.green)),
        controller: widget.controller,
        suggestionsCallback: widget.suggestionsCallback,
        itemBuilder: widget.itemBuilder,
        onSelected: widget.onSelected,
      ),
    );
  }

  String getValue() {
    return widget.controller.text;
  }
}
