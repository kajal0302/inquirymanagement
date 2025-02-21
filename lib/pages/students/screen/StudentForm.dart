import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/components/branchInputField.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/students/apicall/batchListApi.dart';
import 'package:inquirymanagement/pages/students/apicall/branchListApi.dart';
import 'package:inquirymanagement/pages/students/models/batchListModel.dart';
import 'package:inquirymanagement/pages/students/models/branchListModel.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import '../../../components/DynamicStepper.dart';
import '../../../components/buttonField.dart';
import '../../../components/dropDown.dart';
import '../../../utils/lists.dart';
import 'package:inquirymanagement/components/dateField.dart';

bool checkSubmit = false;
final _personalDetailsFormKey = GlobalKey<FormState>();
final _usernamePasswordFormKey = GlobalKey<FormState>();
final _parentsDetailsFormKey = GlobalKey<FormState>();
final _courseDetailsFormKey = GlobalKey<FormState>();
final _installmentDetailsFormKey = GlobalKey<FormState>();
List<String> branchItem = [];
List<String> branchIdItem = [];


class StudentForm extends StatefulWidget {
  final String? id;
  final String? fname;
  final String? lname;

  const StudentForm({super.key, this.id, this.fname,this.lname});

  @override
  State<StudentForm> createState() => _StudentFromState();
}

class _StudentFromState extends State<StudentForm> {
  String? cid, branchId, login_Id, categoryId;
  bool isEdit = true;
  File? selectedFile;
  bool isLoading=true;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController branchController = TextEditingController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentMobileController = TextEditingController();
  TextEditingController parentAddressController = TextEditingController();

  TextEditingController batchController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  TextEditingController discountController = TextEditingController();
  TextEditingController installmentTypeController = TextEditingController();
  TextEditingController joiningDateController = TextEditingController();
  TextEditingController referenceByController = TextEditingController();
  TextEditingController partnerController = TextEditingController();



  @override
  void initState() {
    super.initState();
    isEdit = widget.id == null;
    if (widget.id != null) {
      loadstudentBranchListData();
      // loadstudentBatchListData();
    }
  }



  // Method to load BranchList
  Future<void> loadstudentBranchListData() async {
    StudentBranchListModel? fetchedBranchListData = await fetchStudentBranchListData(context);
    setState(() {
      if (fetchedBranchListData != null &&
          fetchedBranchListData.branches != null &&
          fetchedBranchListData.branches!.isNotEmpty) {
        branchItem =
            fetchedBranchListData.branches!.map((item) => item.name ?? '').toList();
        branchIdItem = fetchedBranchListData.branches!
            .map((item) => item.id.toString() ?? '')
            .toList();
      } else {
        branchItem = [];
      }
      isLoading = false;
    });
  }

  // // Method to load BatchList
  // Future<void> loadstudentBatchListData() async {
  //   StudentBatchListModel? fetchedBatchListData = await fetchStudentBatchListData(context);
  //   setState(() {
  //     if (fetchedBatchListData != null &&
  //         fetchedBatchListData.batches != null &&
  //         fetchedBatchListData.batches!.isNotEmpty) {
  //     } else {
  //       branchItem = [];
  //     }
  //     isLoading = false;
  //   });
  // }


  List<Map> dynamicSteps() {
    return [
      {
        "title": "Personal Details",
        "content": PersonalDetails(
          formKey: _personalDetailsFormKey,
          firstnameController: firstnameController,
          lastnameController: lastnameController,
          mobileController: mobileController,
          whatsappController: whatsappController,
          emailController: emailController,
          birthController: birthController,
          genderController: genderController,
          branchController: branchController,
          isEdit: isEdit,
        )
      },
      {
        "title": "Create Username And Password",
        "content": UsernameAndPassword(
          formKey: _usernamePasswordFormKey,
          usernameController: usernameController,
          passwordController: passwordController,
          confirmController: confirmController,
          isEdit: isEdit,
        )
      },
      {
        "title": "Parent Details",
        "content": ParentDetails(
          formKey: _parentsDetailsFormKey,
          parentNameController: parentNameController,
          parentMobileController: parentMobileController,
          parentAddressController: parentAddressController,
          isEdit: isEdit,
        )
      },
      {
        "title": "Course Details",
        "content": CourseDetails(
          formKey: _courseDetailsFormKey,
          batchController: batchController,
          categoryController: categoryController,
          courseController: courseController,
          isEdit: isEdit,
        )
      },
      {
        "title": "Installment Details",
        "content": InstallmentDetails(
          formKey: _installmentDetailsFormKey,
          discountController: discountController,
          installmentTypeController: installmentTypeController,
          joiningDateController: joiningDateController,
          referenceByController:referenceByController,
          partnerController:partnerController,
          isEdit: isEdit,
        )
      },
    ];
  }



  // void _loadStudentData() {
  //   if (widget.student != null) {
  //     Students? studentData = widget.student;
  //     profilePic = studentData!.image.toString();
  //     firstnameController.text = studentData.fname.toString();
  //     lastnameController.text = studentData.lname.toString();
  //     mobileController.text = studentData.mobileno.toString();
  //     whatsappController.text = studentData.wamobileno.toString();
  //     emailController.text = studentData.email.toString();
  //     birthController.text = studentData.dob.toString();
  //     genderController.text = studentData.gender.toString();
  //
  //     usernameController.text = studentData.username.toString();
  //     passwordController.text = studentData.pwd.toString();
  //     confirmController.text = studentData.pwd.toString();
  //
  //     parentNameController.text = studentData.parentname.toString();
  //     parentMobileController.text = studentData.parentmobileno.toString();
  //     parentAddressController.text = studentData.address.toString();
  //
  //     discountController.text = studentData.discount.toString();
  //     batchController.text = studentData.batchName.toString();
  //     subjectController.text = studentData.subjects.toString();
  //     standardController.text = studentData.standardId.toString();
  //     joinDateController.text = studentData.joiningDate.toString();
  //     refController.text = studentData.reference.toString();
  //
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForAboutPage(context, "${widget.fname} ${widget.lname}", InquiryReportPage()),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(userImg), // Use local asset image
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: DynamicStepper(dynamicSteps: dynamicSteps(), voidCallback: () {  },),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.id != null ? isEdit : true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: button(
            btnHeight: 50,
            btnWidth: MediaQuery.of(context).size.width,
            onClick: () async {
              setState(() {
                checkSubmit = true;
              });
              bool isPersonalDetailsFormValid = _personalDetailsFormKey.currentState!.validate();
              bool isUsernamePasswordFormValid = _usernamePasswordFormKey.currentState!.validate() ;
              bool isParentsDetailsFormValid = _parentsDetailsFormKey.currentState!.validate();
              bool isCourseDetailsFormValid = _courseDetailsFormKey.currentState?.validate() ?? false;
              bool isInstallementDetailsFormValid = _installmentDetailsFormKey.currentState?.validate() ?? false;

              //Message according to forms
              List<String> invalidForms = [];

              if (!isPersonalDetailsFormValid) invalidForms.add("Personal Details Form");
              if (!isUsernamePasswordFormValid) invalidForms.add("Username & Password Form");
              if (!isParentsDetailsFormValid) invalidForms.add("Parents Details Form");
              if (!isCourseDetailsFormValid) invalidForms.add("Course Details Form");
              if (!isInstallementDetailsFormValid) invalidForms.add("Installment Details Form");

              // Proceed only if all forms are valid
              // if (invalidForms.isEmpty) {
              //
              //   int index = standardList.indexWhere((e) =>
              //           e.toLowerCase() == standardController.text.toLowerCase());
              //
              //   // Assuming subjectData and batchData are not null
              //   String subjectList = subjectData!.courses!
              //       .where((batch) => batch.isChecked == true)
              //       .map((batch) => batch.id)
              //       .join(',') ?? '';
              //
              //   String checkedBatches = batchData!.batches!
              //       .where((batch) => batch.isChecked == true)
              //       .map((batch) => batch.id)
              //       .join(',');
              //
              //   // Ensure that the selected batches and subjects are not empty
              //   if (checkedBatches.isEmpty || subjectList.isEmpty) {
              //     callSnackBar(
              //       checkedBatches.isEmpty
              //           ? "Batches cannot be empty"
              //           : "Subject cannot be empty",
              //       "danger",
              //     );
              //     return;
              //   }
              //
              //   // Call your studentFormSubmit method with the required data
              //   var data = await studentFormSubmit(
              //     widget.id ?? "",
              //     standardIdList[index],
              //     subjectList,
              //     parentNameController.text,
              //     genderController.text,
              //     checkedBatches,
              //     discountController.text,
              //     mobileController.text,
              //     'Running',
              //     refController.text,
              //     passwordController.text,
              //     lastnameController.text,
              //     "",
              //     branchId!,
              //     whatsappController.text,
              //     emailController.text,
              //     login_Id!,
              //     firstnameController.text,
              //     joinDateController.text,
              //     parentAddressController.text,
              //     "",
              //     parentMobileController.text,
              //     birthController.text,
              //     confirmController.text,
              //     usernameController.text,
              //     cid!,
              //     selectedFile,
              //   );
              //
              //   // Handle the response from the submission
              //   if (data?.status == success) {
              //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Student()));
              //     callSnackBar(data!.message.toString(), success);
              //   } else {
              //     callSnackBar(data!.message.toString(), "danger");
              //   }
              // }  else {
              //   String errorMessage = "Please fix errors in the following forms: ${invalidForms.join(', ')}";
              //   callSnackBar(errorMessage, "danger");
              // }
            },
            btnLbl: "Add Students",
            btnClr: primaryColor,
            btnFontWeigth: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// Installment Details Section
class InstallmentDetails extends StatelessWidget {
  InstallmentDetails({super.key,
    required this.formKey,
    required this.discountController,
    required this.installmentTypeController,
    required this.joiningDateController,
    required this.referenceByController,
    required this.partnerController,
    required this.isEdit});

  final GlobalKey<FormState> formKey;
  bool isEdit;
  final TextEditingController discountController;
  final TextEditingController installmentTypeController;
  final TextEditingController joiningDateController;
  final TextEditingController referenceByController;
  final TextEditingController partnerController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
        ],
      ),
    );
  }
}

// Course Details Section
class CourseDetails extends StatelessWidget {
  CourseDetails({super.key,
    required this.formKey,
    required this.batchController,
    required this.categoryController,
    required this.courseController,
    required this.isEdit});

  final GlobalKey<FormState> formKey;
  bool isEdit;
  final TextEditingController batchController;
  final TextEditingController categoryController;
  final TextEditingController courseController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [

        ],
      ),
    );
  }
}

// Parents Details Section
class ParentDetails extends StatelessWidget {
  ParentDetails({super.key,
      required this.formKey,
      required this.parentNameController,
      required this.parentMobileController,
      required this.parentAddressController,
      required this.isEdit});

  final GlobalKey<FormState> formKey;
  bool isEdit;
  final TextEditingController parentNameController;
  final TextEditingController parentMobileController;
  final TextEditingController parentAddressController;

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
                if (checkSubmit && (value == null || value.isEmpty)) {
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
              if (checkSubmit) {
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
              if (checkSubmit && (value == null || value.isEmpty)) {
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

// Username & Password Details Section
class UsernameAndPassword extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  bool isEdit;


  UsernameAndPassword({super.key,
      required this.formKey,
      required this.usernameController,
      required this.passwordController,
      required this.confirmController,
      required this.isEdit});

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
              if (checkSubmit && (value == null || value.isEmpty)) {
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
              if (checkSubmit) {
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
              if (checkSubmit) {
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


// Personal Details Section
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
    required this.isEdit,
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
  bool isEdit;


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
                if (checkSubmit && (value == null || value.isEmpty)) {
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
                if (checkSubmit && (value == null || value.isEmpty)) {
                  return "Please enter last name";
                }
                return null;
              },
            ),
            BranchInputTxt(
              label: "Parent's Mobile",
              keyboardType: TextInputType.number,
              textColor: black,
              floatingLabelColor: preIconFillColor,
              controller:mobileController ,
              validator: (value) {
                if (checkSubmit) {
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
              label: "Email",
              textColor:  black,
              floatingLabelColor: preIconFillColor,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (checkSubmit) {
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
            DropDown(
              preSelectedValue: branchController.text.isNotEmpty &&
                  branchItem.contains(branchController.text)
                  ? branchController.text
                  : (branchItem.isNotEmpty ? branchItem.first : ''),
              controller: branchController,
              items: branchItem,
              status: true,
              lbl: "Select Branch",
              onChanged: (str) {
                print(str);
              },
            ),
          ],
        ),
      ),
    );
  }

}


//
// Future<void> showDynamicCheckboxDialog(BuildContext context,
//     BatchesModel? batches, VoidCallback onOkPressed) async {
//   batches == null || batches.batches == null || batches.batches!.isEmpty;
//
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Batches'),
//         content: StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return SingleChildScrollView(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                     children: batches!.batches!.map((batch) {
//                   return CheckboxListTile(
//                     title: Text(batch.name ?? ""),
//                     value: batch.isChecked ?? false,
//                     onChanged: (e) {
//                       setState(() {
//                         batch.isChecked = e!;
//                       });
//                     },
//                   );
//                 }).toList()),
//               ),
//             );
//           },
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.pop(context,true);
//             },
//           ),
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               onOkPressed();
//               Navigator.pop(context,true);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
// Future<void> showSubjectCheckboxDialog(BuildContext context,
//     subjectModel? subjectData, VoidCallback onOkPressed) async {
//   // subjectData == null || subjectData.courses == null || subjectData.courses!.isEmpty;
//   if (subjectData == null || subjectData.courses == null || subjectData.courses!.isEmpty) {
//     return;
//   }
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Subjects'),
//         content: StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return SingleChildScrollView(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Column(
//                     children: subjectData.courses!.map((course) {
//                   return CheckboxListTile(
//                     title: Text(course.name ?? ""),
//                     value: course.isChecked ?? false,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         course.isChecked = value ?? false;
//                       });
//                     },
//                   );
//                 }).toList()),
//               ),
//             );
//           },
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.pop(context,true);
//             },
//           ),
//           TextButton(
//             child: const Text('OK'),
//             onPressed: () {
//               onOkPressed();
//               Navigator.pop(context,true);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
