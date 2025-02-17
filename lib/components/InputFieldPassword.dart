import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import '../common/size.dart';

class InputFieldPassword extends StatefulWidget {
  final String label;
  final Color textColor;
  final Color floatingLabelColor;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final int? maxLength;
  final TextInputType keyboardType;
  final int? maxLines;

  const InputFieldPassword({
    super.key,
    required this.label,
    required this.textColor,
    required this.floatingLabelColor,
    required this.controller,
    this.validator,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  _InputFieldPasswordState createState() => _InputFieldPasswordState();
}

class _InputFieldPasswordState extends State<InputFieldPassword> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double borderRadius = (widget.maxLines != null && widget.maxLines! > 1) ? 15.0 : 50.0;
    bool isMultiline = widget.maxLines != null && widget.maxLines! > 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: TextStyle(color: widget.textColor),
        validator: widget.validator,
        cursorColor: preIconFillColor,
        controller: widget.controller,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        obscureText: _obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: grey_500,
            fontSize: px15,
          ),
          floatingLabelStyle: TextStyle(
            color: colorBlackAlpha,
            fontSize: px16,
            fontWeight: FontWeight.normal,
          ),
          alignLabelWithHint: isMultiline,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
      ),
    );
  }
}