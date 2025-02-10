import 'package:flutter/material.dart';

class InputTxt extends StatelessWidget {
  final Icon? prefixIcon;
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const InputTxt({
    super.key,
    this.prefixIcon,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            style: TextStyle(color: Colors.black),
            validator: validator,
            cursorColor: Colors.blue,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: prefixIcon,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50),
              ),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }
}
