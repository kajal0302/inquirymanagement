import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/branchInputField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/utils/lists.dart';

class StepOne extends StatelessWidget {
  const StepOne(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.mobileNo,
      required this.feedback,
      required this.reference,
      required this.isSubmitted});

  final TextEditingController firstName,
      lastName,
      mobileNo,
      feedback,
      reference;

  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BranchInputTxt(
          label: "First Name",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: firstName,
          maxLength: 50,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter First Name'
                : null;
          },
        ),
        BranchInputTxt(
          label: "Last Name",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: lastName,
          maxLength: 50,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Last Name'
                : null;
          },
        ),
        BranchInputTxt(
          label: "Mobile No.",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: mobileNo,
          type: "number",
          maxLength: 10,
          validator: (value) {
            if (isSubmitted && (value == null || value.isEmpty)) {
              return 'Please enter Mobile No.';
            } else if (value.toString().length < 10) {
              return 'Minimum Length Should be 10';
            } else if (value.toString().length > 10) {
              return 'Maximum Length Should be 10';
            }
            return null;
          },
        ),
        DropDown(
          key: Key('dropDown1'),
          preSelectedValue: reference.text.isNotEmpty
              ? (reference.text ?? '')
              : (referenceBy.isNotEmpty ? referenceBy.first : ''),
          controller: reference,
          items: referenceBy,
          status: true,
          lbl: "Select Reference",
        ),
        BranchInputTxt(
          label: "Feedback History",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: feedback,
          maxLength: 50,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Feedback History'
                : null;
          },
        ),

      ],
    );
  }
}
