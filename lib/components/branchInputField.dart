import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import '../common/size.dart';

class BranchInputTxt extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color floatingLabelColor;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final int? maxLength;
  final TextInputType keyboardType; // Keyboard type for different inputs
  final int? maxLines; // Allows multi-line for address input

  const BranchInputTxt({
    super.key,
    required this.label,
    required this.textColor,
    required this.floatingLabelColor,
    required this.controller,
    this.validator,
    this.maxLength,
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
        cursorColor: preIconFillColor,
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10.0),
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
                fontSize: px18,
            ),
            floatingLabelStyle: TextStyle(
                color: floatingLabelColor,
                fontSize: px18,
              fontWeight: FontWeight.normal
            ),
          alignLabelWithHint: isMultiline
        ),
      ),
    );
  }
}
