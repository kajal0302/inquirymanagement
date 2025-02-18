import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/InputFieldPassword.dart';
import 'package:inquirymanagement/components/branchInputField.dart';
import 'package:inquirymanagement/components/dateField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/components/inputPasswordField.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/utils/lists.dart';

class StepTwo extends StatelessWidget {
  const StepTwo(
      {super.key,
      required this.username,
      required this.password,
      required this.confirmPassword,
      required this.selectBranch,
      required this.joiningDate,
      required this.userRole,
      required this.branchProvider,
      required this.isSubmitted});

  final TextEditingController username,
      password,
      confirmPassword,
      selectBranch,
      joiningDate,
      userRole;

  final bool isSubmitted;
  final BranchProvider branchProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BranchInputTxt(
          label: "Username",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          maxLength: 50,
          controller: username,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Username'
                : null;
          },
        ),
        InputFieldPassword(
          label: "Password",
          maxLength: 20,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: password,
          validator: (value) {
            if(isSubmitted && (value == null || value.isEmpty)){
              return 'Please Enter Password';
            }else if(isSubmitted && (password.text.toString().length < 5)){
              return 'Minimum Length Should be 5';
            }
            return null;
          },
        ),
        InputFieldPassword(
          label: "Confirm Password",
          maxLength: 20,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: confirmPassword,
          validator: (value) {
            if(isSubmitted && (value == null || value.isEmpty)){
              return 'Please Enter Confirm Password';
            }else if(isSubmitted && (password.text.toString() != value)){
              return 'Password And Confirm Password Did Not Match';
            }
            return null;
          },
        ),
        DropDown(
          preSelectedValue: branchProvider.branch?.branches != null &&
                  branchProvider.branch!.branches!
                      .any((b) => b.id.toString() == selectBranch.text)
              ? selectBranch.text
              : (branchProvider.branch != null &&
                      branchProvider.branch!.branches!.isNotEmpty
                  ? branchProvider.branch!.branches!.first.id.toString()
                  : null),
          controller: selectBranch,
          mapItems: branchProvider.branch?.branches!
              .map((b) => {"id": b.id.toString(), "value": b.name.toString()})
              .toSet() // Ensure uniqueness
              .toList(),
          status: true,
          lbl: "Select Branch",
        ),
        DateField(
          firstDate: DateTime(1980, 1, 1),
          lastDate: DateTime.now(),
          label: "Joining Date",
          controller: joiningDate,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Joining Date'
                : null;
          },
        ),
        DropDown(
          preSelectedValue: userRole.text.isNotEmpty
              ? (userRole.text ?? '')
              : (userRoleList.isNotEmpty ? userRoleList.first : ''),
          controller: userRole,
          items: userRoleList,
          status: true,
          lbl: "Select Employee Role",
        ),
      ],
    );
  }
}
