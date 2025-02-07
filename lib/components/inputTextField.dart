import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';


// widget for textField
class InputTxt extends StatelessWidget {
  final Icon? prefixIcon;
  final String label;
  final String? Function(String?)? validator;
  const InputTxt({
    super.key,
    this.prefixIcon,
    required this.label,
    required this.controller,
    this.validator
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextFormField(
        style: TextStyle(color:black),
        validator: validator,
        cursorColor: primaryColor,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
            fillColor: white,
            prefixIcon: prefixIcon,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)
            ),

            hintText: label
        ),

      ),
    );
  }
}