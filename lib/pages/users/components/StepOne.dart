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
        required this.gender,
        required this.isSubmitted
      });

  final TextEditingController fullName,
      address,
      mobileNo,
      emailId,
      designation,
      birthDate,
      gender;

  final bool isSubmitted;

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
          maxLength: 50,
          validator: (value){
            return isSubmitted && (value == null || value.isEmpty)
            ? 'Please enter Full name'
            : null;
          },
        ),
        BranchInputTxt(
          label: "Address",
          maxLines: 3,
          maxLength: 150,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: address,
          validator: (value){
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please enter Address'
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
          validator: (value){
            if(isSubmitted && (value == null || value.isEmpty)){
              return 'Please enter Mobile No.';
            }else if(value.toString().length < 10){
              return 'Minimum Length Should be 10';
            }else if(value.toString().length > 10){
              return 'Maximum Length Should be 10';
            }
            return null;
          },
        ),
        BranchInputTxt(
          label: "Email Id",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: emailId,
          type: "email",
          validator: (value){
            if(isSubmitted && (value == null || value.isEmpty)){
              return 'Please enter Email Id';
            }else if(! EmailValidator(value ?? "")){
              return "Enter Valid EmailId";
            }
            return null;
          },
        ),
        BranchInputTxt(
          label: "Designation",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: designation,
          validator: (value){
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please enter Designation'
                : null;
          },
        ),
        DateField(
          firstDate: DateTime(1980, 1, 1),
          lastDate: DateTime.now(),
          label: "Birth Date",
          controller: birthDate,
          validator: (value){
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please enter Birth Date'
                : null;
          },
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