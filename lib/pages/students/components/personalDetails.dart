import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import 'package:inquirymanagement/pages/students/provider/branchProvider.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../components/branchInputField.dart';
import '../../../components/dateField.dart';
import '../../../components/dropDown.dart';
import '../../../utils/lists.dart';

class PersonalDetails extends StatelessWidget {
  PersonalDetails({
    super.key,
    required this.formKey,
    required this.firstnameController,
    required this.lastnameController,
    required this.mobileController,
    required this.whatsappController,
    required this.emailController,
    required this.birthController,
    required this.genderController,
    required this.branchController,
    required this.studentBranchProvider,
    required this.isSubmitted
  });
  final GlobalKey<FormState> formKey;
  final TextEditingController firstnameController;
  final TextEditingController lastnameController;
  final TextEditingController mobileController;
  final TextEditingController whatsappController;
  final TextEditingController emailController;
  final TextEditingController birthController;
  final TextEditingController genderController;
  final TextEditingController branchController;
  final bool isSubmitted;
  final StudentBranchProvider studentBranchProvider;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            BranchInputTxt(
              label:  "First Name",
              textColor: black,
              floatingLabelColor: preIconFillColor,
              controller: firstnameController,
              maxLength: 40,
              validator: (value) {
                if (isSubmitted && (value == null || value.isEmpty)) {
                  return "Please enter first name";
                }
                return null;
              },
            ),
            BranchInputTxt(
              label:  "Last Name",
              textColor: black,
              floatingLabelColor: preIconFillColor,
              controller: lastnameController,
              maxLength: 40,
              validator: (value) {
                if (isSubmitted && (value == null || value.isEmpty)) {
                  return "Please enter last name";
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child:
                  BranchInputTxt(
                    maxLength: 10,
                    label: "Mobile Number",
                    type: "number",
                    textColor: black,
                    floatingLabelColor: preIconFillColor,
                    controller:mobileController ,
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
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    whatsappController.text = mobileController.text;
                  },
                  child: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: colorConfirm,
                    size: px28,
                  ),
                )
              ],
            ),
            BranchInputTxt(
              label: "Whatsapp Number",
              type: "number",
              textColor: black,
              maxLength: 10,
              floatingLabelColor: preIconFillColor,
              controller:whatsappController ,
              validator: (value) {
                if (isSubmitted) {
                  String trimmedValue = value?.trim() ?? "";

                  if (trimmedValue.isEmpty) {
                    return 'Please enter your whatsapp number';
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
              label: "Email",
              textColor:  black,
              floatingLabelColor: preIconFillColor,
              controller: emailController,
              type: "email",
              validator: (value) {
                if (isSubmitted) {
                  //If value is null, it defaults to an empty string ("").
                  String trimmedValue = value?.trim() ?? "";
                  if (trimmedValue.isEmpty) {
                    return 'Please enter branch email';
                  }
                  // Regular expression for validating an email
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(trimmedValue)) {
                    return 'Please enter a valid email address';
                  }
                }
                return null;
              },

            ),
            DateField(firstDate: DateTime(1980, 1, 1), lastDate: DateTime.now(), label: "Birth Date", controller:birthController ),
            DropDown(
                preSelectedValue: genderController.text.isNotEmpty ? (genderController.text ?? '') : (genderList.isNotEmpty ? genderList.first : ''),
                controller:genderController,
                items:genderList,
                status: true,
                lbl: "Select Gender"),
            SizedBox(height: 10,),
            TextWidget(labelAlignment: Alignment.topLeft, label: "Select Branch", labelClr: black, labelFontWeight: FontWeight.normal, labelFontSize: px15),
            DropDown(
              preSelectedValue: (studentBranchProvider.branch?.branches != null &&
                  studentBranchProvider.branch!.branches!.any(
                          (b) => b.id.toString() == branchController.text))
                  ? branchController.text
                  : (studentBranchProvider.branch?.branches?.isNotEmpty == true
                  ? studentBranchProvider.branch!.branches!.first.id.toString()
                  : null),
              controller: branchController,
              mapItems: studentBranchProvider.branch?.branches
                  ?.map((b) => {"id": b.id.toString(), "value": b.name.toString()})
                  .toSet()
                  .toList() ??
                  [],
              status: true,
              lbl: "Select Branch",
            ),
          ],
        ),
      ),
    );
  }
}