import 'package:flutter/cupertino.dart';

import '../../../common/color.dart';
import '../../../components/branchInputField.dart';

class ParentDetails extends StatelessWidget {
  ParentDetails({super.key,
    required this.formKey,
    required this.parentNameController,
    required this.parentMobileController,
    required this.parentAddressController,
    required this.isEdit,
    required this.isSubmitted
  });

  final GlobalKey<FormState> formKey;
  bool isEdit;
  final TextEditingController parentNameController;
  final TextEditingController parentMobileController;
  final TextEditingController parentAddressController;
  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          BranchInputTxt(
            label:  "Parent's Name",
            textColor: black,
            floatingLabelColor: preIconFillColor,
            controller: parentNameController,
            maxLength: 40,
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return "Please Enter Parent Name";
              }
              return null;
            },
          ),
          BranchInputTxt(
            label: "Parent's Mobile",
            keyboardType: TextInputType.number,
            textColor: black,
            floatingLabelColor: preIconFillColor,
            controller: parentMobileController,
            validator: (value) {
              if (isSubmitted) {
                String trimmedValue = value?.trim() ?? "";

                if (trimmedValue.isEmpty) {
                  return 'Please enter your mobile number';
                }
                if (trimmedValue.length != 10) {
                  return 'Mobile number must be exactly 10 digits';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(trimmedValue)) {
                  return 'Please enter a valid numeric mobile number';
                }
              }
              return null; // No error
            },
          ),
          BranchInputTxt(
            label: "Address",
            textColor:  black,
            floatingLabelColor:preIconFillColor,
            controller: parentAddressController,
            maxLines: 3,
            keyboardType: TextInputType.streetAddress,
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return 'Please enter address';
              }
              return null; // No error
            },
          ),
        ],
      ),
    );
  }
}
