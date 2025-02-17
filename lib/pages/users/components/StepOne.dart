import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/branchInputField.dart';
import 'package:inquirymanagement/components/dateField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/utils/lists.dart';

class StepOne extends StatelessWidget {
  const StepOne(
      {super.key,
        required this.fullName,
        required this.address,
        required this.mobileNo,
        required this.emailId,
        required this.designation,
        required this.birthDate,
        required this.gender});

  final TextEditingController fullName,
      address,
      mobileNo,
      emailId,
      designation,
      birthDate,
      gender;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BranchInputTxt(
          label: "Full Name",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: fullName,
          validator: (str){
            print("asdfasdf");
            return null;
          },
        ),
        BranchInputTxt(
          label: "Address",
          maxLines: 3,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: address,
        ),
        BranchInputTxt(
          label: "Mobile No.",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: mobileNo,
        ),
        BranchInputTxt(
          label: "Email Id",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: emailId,
        ),
        BranchInputTxt(
          label: "Designation",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: designation,
        ),
        DateField(
          firstDate: DateTime(1980, 1, 1),
          lastDate: DateTime.now(),
          label: "Birth Date",
          controller: birthDate,
        ),
        DropDown(
          key: Key('dropDown1'),
          preSelectedValue: gender.text.isNotEmpty
              ? (gender.text ?? '')
              : (genderList.isNotEmpty ? genderList.first : ''),
          controller: gender,
          items: genderList,
          status: true,
          lbl: "Gender",
        ),
      ],
    );
  }
}