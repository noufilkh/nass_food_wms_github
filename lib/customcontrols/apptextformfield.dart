import 'package:flutter/material.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';

class AppTextFormField extends StatefulWidget {
  final String labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusnode;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final bool? isPasswordField;
  final bool? ismandatoryField;
  final EdgeInsetsGeometry? textFieldPadding;

  const AppTextFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.focusnode,
    this.controller,
    this.onFieldSubmitted,
    this.isPasswordField,
    this.ismandatoryField,
    this.textFieldPadding,
  });

  @override
  AppTextFormFieldState createState() => AppTextFormFieldState();
}

class AppTextFormFieldState extends State<AppTextFormField> {
  @override
  void initState() {
    super.initState();
    //_controller.text = widget.initialValue ?? '';
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    widget.focusnode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          (widget.textFieldPadding == null)
              ? AppFunctions.textfieldbottompadding
              : widget.textFieldPadding ?? EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
        ),
        style: Theme.of(context).textTheme.titleMedium,
        obscureText: widget.isPasswordField ?? false,
        validator: (value) {
          if (widget.ismandatoryField == true) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.labelText}';
            }
          }
          if (widget.validator != null) {
            return widget.validator!(value);
          }
          return null;
        },
        controller: widget.controller ?? TextEditingController(),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onTap: () {
          if (widget.controller != null) {
            widget.controller!.selection = TextSelection(
              baseOffset: 0,
              extentOffset: widget.controller!.text.length,
            );
          }
        },
        onFieldSubmitted: (value) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!(value);
          }
        },
      ),
    );
  }

  // String getValue() {
  //   return _controller.text;
  // }
}
