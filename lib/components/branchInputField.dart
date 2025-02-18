import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inquirymanagement/common/color.dart';
import '../common/size.dart';

class BranchInputTxt extends StatelessWidget {
  final String label;
  final Color textColor;
  final String type;
  final Color floatingLabelColor;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final int? maxLength;
  final bool isPwd;
  final bool readOnly;
  final TextInputType keyboardType; // Keyboard type for different inputs
  final int? maxLines; // Allows multi-line for address input

  const BranchInputTxt({
    super.key,
    required this.label,
    this.type = "text",
    required this.textColor,
    required this.floatingLabelColor,
    required this.controller,
    this.validator,
    this.maxLength,
    this.readOnly = false,
    this.isPwd = false,
    this.keyboardType = TextInputType.text, // Default is normal text input
    this.maxLines = 1, // Default is single-line
  });

  @override
  Widget build(BuildContext context) {
    double borderRadius = (maxLines != null && maxLines! > 1) ? 15.0 : 50.0;
    bool isMultiline = maxLines != null && maxLines! > 1; // Check if multiline

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        style: TextStyle(color: textColor),
        validator: validator,
        readOnly: readOnly,
        cursorColor: preIconFillColor,
        controller: controller,
        maxLength: maxLength,
        keyboardType: _getKeyboardType(),
        maxLines: maxLines,
        obscureText: isPwd,
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
            labelText: label,
            labelStyle: TextStyle(
              color: grey_500,
              fontSize: px15,
            ),
            floatingLabelStyle: TextStyle(
                color: colorBlackAlpha,
                fontSize: px17,
                fontWeight: FontWeight.normal),
            alignLabelWithHint: isMultiline),
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (type) {
      case "number":
        return TextInputType.number;
      case "email":
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }

}
