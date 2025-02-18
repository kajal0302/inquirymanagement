import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// widget for textField
class InputPasswordTxt extends StatefulWidget {
  final Icon? prefixIcon;
  final String label;
  final bool icon;

  const InputPasswordTxt(
      {super.key,
      this.prefixIcon,
      required this.label,
      required this.password,
      this.icon = true,
      this.validator});

  final TextEditingController password;
  final String? Function(String?)? validator;

  @override
  State<InputPasswordTxt> createState() => _InputPasswordTxtState();
}

class _InputPasswordTxtState extends State<InputPasswordTxt> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        style: TextStyle(color: black),
        validator: widget.validator,
        obscureText: isPasswordVisible,
        cursorColor: primaryColor,
        controller: widget.password,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          filled: true,
          fillColor: white,
          prefixIcon: widget.icon
              ? Icon(
                  Icons.lock,
                  size: px28,
                  color: preIconFillColor,
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(50),
          ),
          hintText: widget.label,
          suffixIcon: GestureDetector(
            child: Icon(
              isPasswordVisible
                  ? FontAwesomeIcons.eye
                  : FontAwesomeIcons.eyeSlash,
              size: px16,
              color: black,
            ),
            onTap: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
