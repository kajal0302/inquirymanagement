import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final bool isEnabled;
  final TextEditingController controller;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? Function(String?)? validator;

  const CustomDatePicker({
    Key? key,
    required this.label,
    this.isEnabled = true,
    required this.controller,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.validator,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      widget.controller.text = _formatDate(widget.initialDate!);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate() async {
    DateTime initialDate = widget.controller.text.isNotEmpty
        ? DateTime.tryParse(widget.controller.text) ?? DateTime.now()
        : widget.initialDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        widget.controller.text = _formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.isEnabled
            ? IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: _selectDate,
        )
            : null,
      ),
      readOnly: true,
      onTap: widget.isEnabled ? _selectDate : null,
      validator: widget.validator,
    );
  }
}
