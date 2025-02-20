import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../common/color.dart';
import '../common/size.dart';

class DateField extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final double txtFieldHeigth;
  final String txtFieldInSideLabel;
  final bool status;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const DateField({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.status,
    required this.txtFieldHeigth,
    required this.txtFieldInSideLabel,
    required this.controller,
    this.validator,
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
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.black,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent,
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
        widget.controller
          ..text = formatter.format(_selectedDate!)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: widget.controller.text.length,
              affinity: TextAffinity.upstream));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: px15,
        ),
        TextFormField(
            validator:widget.validator,
            enabled: widget.status,
            style: TextStyle(color: black,fontSize: px15),
            textInputAction: TextInputAction.go,
            controller: widget.controller,
            readOnly: true,
            maxLength: 20,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              counter: null,
              counterText: "",
              labelText: widget.txtFieldInSideLabel,
              errorText:widget.validator != null ? widget.validator!(widget.controller.text) : null
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate(context);
            },
          ),

      ],
    );
  }
}
