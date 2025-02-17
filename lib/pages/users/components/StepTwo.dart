import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
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
      required this.branchProvider});

  final TextEditingController username,
      password,
      confirmPassword,
      selectBranch,
      joiningDate,
      userRole;

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
          controller: username,
        ),
        InputPasswordTxt(
          label: "Password",
          password: password,
        ),
        InputPasswordTxt(
          label: "Confirm Password",
          password: confirmPassword,
        ),
        DropDown(
          preSelectedValue: branchProvider.branch?.branches != null &&
              branchProvider.branch!.branches!.any((b) => b.id.toString() == selectBranch.text)
              ? selectBranch.text
              : (branchProvider.branch != null && branchProvider.branch!.branches!.isNotEmpty
              ? branchProvider.branch!.branches!.first.id.toString()
              : null),
          controller: selectBranch,
          mapItems: branchProvider.branch!.branches!
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
            controller: joiningDate),
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
