import 'package:flutter/cupertino.dart';

import '../../../common/color.dart';
import '../../../components/branchInputField.dart';

class UsernameAndPassword extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  bool isEdit;
  final bool isSubmitted;


  UsernameAndPassword({super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.confirmController,
    required this.isEdit,
    required this.isSubmitted
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          BranchInputTxt(
            label:  "Username",
            textColor: black,
            floatingLabelColor: preIconFillColor,
            controller: usernameController,
            maxLength: 40,
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return "Please enter username";
              }
              return null;
            },
          ),

          BranchInputTxt(
            label:  "Password",
            textColor: black,
            floatingLabelColor: preIconFillColor,
            controller: passwordController,
            validator: (value) {
              if (isSubmitted) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters long";
                }
              }
              return null; // No validation errors before clicking submit
            },
          ),

          BranchInputTxt(
            label:  "Confirm Password",
            textColor: black,
            floatingLabelColor: preIconFillColor,
            controller: confirmController,
            validator: (value) {
              if (isSubmitted) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password";
                }
                if (value != passwordController.text) {
                  return "Your password don't match. Please try again.";
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}