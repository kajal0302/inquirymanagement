import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/course/components/showDynamicCheckboxDialog.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import '../common/size.dart';

class InkWellInputField extends StatelessWidget {
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
  final BuildContext context;
  final Function(CourseModel) onOkPressed;
  final CourseModel? courses;

  const InkWellInputField({
    super.key,
    required this.context,
    required this.label,
    required this.onOkPressed,
    this.type = "text",
    required this.textColor,
    required this.floatingLabelColor,
    required this.controller,
    required this.courses,
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
      child: InkWell(
        onTap: ()=>showDynamicCheckboxDialog(context,onOkPressed, courses,() {},),
        child: TextFormField(
          style: TextStyle(color: textColor),
          validator: validator,
          readOnly: readOnly,
          enabled: false,
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
