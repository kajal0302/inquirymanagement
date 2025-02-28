import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:intl/intl.dart';
import '../common/size.dart';

class DateField extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final String label;
  final bool isEnabled;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool showBottomBorder;

  const DateField({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.label,
    required this.controller,
    this.isEnabled = true,
    this.validator,
    this.showBottomBorder = false,
  });

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime? _selectedDate;

  void _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: preIconFillColor, // background of the date
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: preIconFillColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        widget.controller.text = formatter.format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: TextStyle(color: black),
        validator: widget.validator,
        cursorColor: preIconFillColor,
        controller: widget.controller,
        readOnly: true,
        enabled: widget.isEnabled,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: widget.showBottomBorder
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: grey_500, width: 2),
          )
              : OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: widget.showBottomBorder
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: grey_500, width: 2),
          )
              : OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: grey_500,
            fontSize: px15,
          ),

          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50.0),
          ),

          floatingLabelStyle: TextStyle(
            color: black,
            fontSize: px18,
            fontWeight: FontWeight.normal,
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _selectDate(context);
        },
      ),
    );
  }
}