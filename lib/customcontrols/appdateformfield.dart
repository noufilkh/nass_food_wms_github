import 'package:flutter/material.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:intl/intl.dart'; // Add intl package in pubspec.yaml

// ignore: must_be_immutable
class DateInputField extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  String label;
  FocusNode? focusnode = FocusNode();
  Function? onsubmit;
  DateTime? initialDate;
  DateTime firstDate;
  DateTime lastDate;

  DateInputField({
    super.key,
    required this.controller,
    required this.label,
    this.focusnode,
    this.onsubmit,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  DateInputFieldState createState() => DateInputFieldState();
}

class DateInputFieldState extends State<DateInputField> {
  final DateFormat _formatter = DateFormat('dd-MMM-yyyy');

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = _formatter.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppFunctions.textfieldbottompadding,
      child: TextFormField(
        focusNode: widget.focusnode,
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ),
        keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter a date';
          try {
            _formatter.parseStrict(value);
            return null;
          } catch (_) {
            return 'Invalid format. Use dd-MMM-yyyy';
          }
        },
        onFieldSubmitted: (value) {
          widget.onsubmit!();
        },
      ),
    );
  }
}
