import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inquirymanagement/common/color.dart';
import '../../../common/size.dart';
import '../../../components/DateFieldWidget.dart';
import '../../../components/DynamicStepper.dart';
import '../../../components/FromInputBox.dart';
import '../../../components/buttonField.dart';
import '../../../components/dropDown.dart';
import '../../../components/lists.dart';
import '../models/StudentModel.dart';

bool checkSubmit = false;
final _personalDetailsFormKey = GlobalKey<FormState>();
final _usernamePasswordFormKey = GlobalKey<FormState>();
final _parentsDetailsFormKey = GlobalKey<FormState>();
final _standardDetailsFormKey = GlobalKey<FormState>();


class StudentForm extends StatefulWidget {
  final String? id;
  final Students? student;

  const StudentForm({super.key, this.id, this.student});

  @override
  State<StudentForm> createState() => _StudentFromState();
}

class _StudentFromState extends State<StudentForm> {
  String? cid, branchId, login_Id, categoryId;
  List<String> standardList = [];
  List<String> standardIdList = [];
  bool isEdit = true;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentMobileController = TextEditingController();
  TextEditingController parentAddressController = TextEditingController();

  TextEditingController discountController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController standardController = TextEditingController();
  TextEditingController joinDateController = TextEditingController();
  TextEditingController refController = TextEditingController();


  @override
  void initState() {
    super.initState();
    isEdit = widget.id == null;
    if (widget.id != null) {
      // _loadStudentData();
    }
  }




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
        "title": "Standard Details",
        "content": StandardDetails(
          formKey: _standardDetailsFormKey,
            subjectController: subjectController,
            discountController: discountController,
            joinDateController: joinDateController,
            standardList: standardList,
            standardController: standardController,
            refController: refController,
            batchController: batchController,
            // batchesData: [],
            // subjectData: [],
            callBackFun: () {

            },
            isEdit: isEdit,
            add: widget.id == null ? true : false)
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
      appBar: AppBar(title: Text("Student Form"),),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: DynamicStepper(dynamicSteps: dynamicSteps()),
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
              bool isStandardDetailsFormValid = _standardDetailsFormKey.currentState?.validate() ?? false;

              //Message according to forms
              List<String> invalidForms = [];

              if (!isPersonalDetailsFormValid) invalidForms.add("Personal Details Form");
              if (!isUsernamePasswordFormValid) invalidForms.add("Username & Password Form");
              if (!isParentsDetailsFormValid) invalidForms.add("Parents Details Form");
              if (!isStandardDetailsFormValid) invalidForms.add("Standard Details Form");

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


            btnLbl: "Sumnit",
            btnClr: primaryColor,
            btnFontWeigth: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class StandardDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController discountController;
  final TextEditingController batchController;
  final TextEditingController refController;
  final List<String> standardList;
  final TextEditingController joinDateController;
  final TextEditingController standardController;
  final TextEditingController subjectController;
  final Function() callBackFun;
  bool isEdit, add;

  StandardDetails(
      {
        super.key,
        required this.formKey,
      required this.subjectController,
      required this.discountController,
      required this.standardList,
      required this.refController,
      required this.joinDateController,
      required this.standardController,
      required this.batchController,
      required this.callBackFun,
      required this.isEdit,
      required this.add});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FormInputBox(
                title: "Discount",
                textEditingController: discountController,
                type: "number",
                maxLength: 6,
                status: isEdit,
                validator: (value) {
                  if (checkSubmit && (value == null || value.isEmpty)) {
                    return"Please Enter Discount";
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () {
                  // if (isEdit && batchesData!.batches != null) {
                  //   showDynamicCheckboxDialog(context, batchesData, () {
                  //     String checkedBatches = batchesData!.batches!
                  //         .where((batch) => batch.isChecked == true)
                  //         .map((batch) => batch.name)
                  //         .join(', ');
                  //     batchController.text = checkedBatches;
                  //   });
                  // }
                },
                child: FormInputBox(
                  boolStatus: true,
                  title: "Batches",
                  textEditingController: batchController,
                  type: "text",
                  status: !isEdit,
                ),
              ),
              standardList.isNotEmpty
                  ? add
                  ? DropDown(
                  onChanged: (selectedStandard) {
                    standardController.text = selectedStandard;
                    subjectController.text = "";
                    callBackFun();
                  },
                  preSelectedValue: standardController.text.isNotEmpty &&
                      standardList.contains(standardController.text)
                      ? standardController.text
                      : (standardList.isNotEmpty ? standardList.first : ''),
                  lbl: "Select Standard",
                  status: isEdit,
                  items: standardList,
                  controller: standardController)
                  : DropDown(
                  onChanged: (selectedStandard) {
                    standardController.text = selectedStandard;
                    subjectController.text = "";
                    callBackFun();
                  },
                  lbl: "Select Standard",
                  status: isEdit,
                  preSelectedValue: standardController.text.isNotEmpty &&
                      standardList.contains(standardController.text)
                      ? standardController.text
                      : (standardList.isNotEmpty ? standardList.first : ''),
                  items: standardList,
                  controller: standardController)
                  : const DropDown(
                lbl: "Select Standard",
                status: false,
                items: [],
              ),
              const SizedBox(
                height: 10,
              ),
          InkWell(
            onTap: () {
              // if (isEdit && subjectData?.courses != null) {
              //   showSubjectCheckboxDialog(context, subjectData, () {
              //     // Collect only selected courses and update the controller text
              //     String checkedSubjects = subjectData!.courses!
              //         .where((course) => course.isChecked == true)
              //         .map((course) => course.name ?? '')
              //         .join(', ');
              //     subjectController.text = checkedSubjects;
              //
              //   });
              // }
            },
            child: FormInputBox(
              boolStatus: true,
              title: "Subjects",
              textEditingController: subjectController,
              type: "text",
              status: !isEdit,
            ),
          ),
              DateField(
                controller: joinDateController,
                txtFieldHeigth: px55,
                txtFieldInSideLabel: "Joining Date",
                firstDate: DateTime(1980, 1, 1),
                lastDate: DateTime.now(),
                status: isEdit,
                validator: (value) {
                  if (checkSubmit && (value == null || value.isEmpty)) {
                    return "Please Enter Joining Date";
                  }
                  return null;
                },
              ),
              DropDown(
                preSelectedValue: refController.text.isNotEmpty ? (refController.text ?? '') : (referenceBy.isNotEmpty ? referenceBy.first : ''),
                controller:refController,
                items:referenceBy,
                status: isEdit, lbl: "Referenced By",),
            ],
          ),
        ),
      ),
    );
  }
}

class ParentDetails extends StatelessWidget {
  ParentDetails(
      {super.key,
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
    return Card(
      elevation: 4,
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FormInputBox(
                title: "Parent's Name",
                textEditingController: parentNameController,
                maxLength: 40,
                type: "text",
                status: isEdit,
                validator: (value) {
                  if (checkSubmit && (value == null || value.isEmpty)) {
                    return "Please Enter Parent Name";
                  }
                  return null;
                },

              ),
              FormInputBox(
                title: "Parent's Mobile",
                textEditingController: parentMobileController,
                type: "number",
                maxLength: 10,
                status: isEdit,
                validator: (value) {
                  if (checkSubmit) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Parent Mobile No.";
                    } else if (value.length < 6) {
                      return "Mobile No. should be minimum 10";
                    }
                  }
                  return null; // No validation errors before clicking submit
                },
              ),
              FormInputBox(
                title: "Address",
                textEditingController: parentAddressController,
                status: isEdit,
                validator: (value) {
                  if (checkSubmit && (value == null || value.isEmpty)) {
                    return"Please Enter Address";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UsernameAndPassword extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  bool isEdit;


  UsernameAndPassword(
      {
        super.key,
        required this.formKey,
      required this.usernameController,
      required this.passwordController,
      required this.confirmController,
      required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FormInputBox(
                title: "Username",
                textEditingController: usernameController,
                maxLength: 40,
                type: "text",
                status: isEdit,
                validator: (value) {
                  if (checkSubmit && (value == null || value.isEmpty)) {
                    return "Please Enter Username";
                  }
                  return null;
                },
              ),
              FormInputBox(
                title: "Password",
                textEditingController: passwordController,
                status: isEdit,
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
              FormInputBox(
                title: "Confirm Password",
                textEditingController: confirmController,
                status: isEdit,
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
        ),
      ),
    );
  }
}

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
  bool isEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        color: white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                FormInputBox(
                  title: "First Name",
                  textEditingController: firstnameController,
                  maxLength: 40,
                  type: "text",
                  status: isEdit,
                  validator: (value) {
                    if (checkSubmit && (value == null || value.isEmpty)) {
                      return "Please Enter First Name";
                    }
                    return null;
                  },
                ),
                FormInputBox(
                    title: "Last Name",
                    maxLength: 40,
                    textEditingController: lastnameController,
                    type: "text",
                    validator: (value) {
                      if (checkSubmit && (value == null || value.isEmpty)) {
                        return "Please Enter Last Name";
                      }
                      return null;
                    },
                    status: isEdit),
                Row(
                  children: [
                    Expanded(
                      child: FormInputBox(
                        title: "Mobile Number",
                        textEditingController: mobileController,
                        type: "number",
                        maxLength: 10,
                        status: isEdit,
                        validator: (value) {
                          if (checkSubmit) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Phone Number";
                            } else if (value.length != 10) {
                              return "Phone Number Length Should be 10";
                            }
                          }
                          return null;
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
                        color: green,
                      ),
                    )
                  ],
                ),
                FormInputBox(
                  title: "Whatsapp Number",
                  textEditingController: whatsappController,
                  type: "number",
                  maxLength: 10,
                  status: isEdit,
                  validator: (value) {
                    if (checkSubmit && (value == null || value.isEmpty)) {
                      return "Please Enter Whatsapp No.";
                    }
                    return null;
                  },
                ),
                FormInputBox(
                  title: "Email",
                  maxLength: 50,
                  textEditingController: emailController,
                  validator: (value) {
                    if (checkSubmit) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Email";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "Please Enter a Valid Email";
                      }
                    }
                    return null;
                  },

                  onChanged: (value) {
                    if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      checkSubmit = true;
                    } else {
                      checkSubmit = false;
                    }
                  },
                  status: isEdit,
                ),
                DateField(
                  validator: (value) {
                    if (checkSubmit && (value == null || value.isEmpty)){
                      return "Please Enter Birth Date";
                    }
                    return null;
                  },
                  controller: birthController,
                  status: isEdit,
                  txtFieldHeigth: px55,
                  txtFieldInSideLabel: "Birth Date",
                  firstDate: DateTime(1980, 1, 1),
                  lastDate: DateTime.now(),
                ),
                DropDown(
                  preSelectedValue: genderController.text.isNotEmpty ? (genderController.text ?? '') : (gender.isNotEmpty ? gender.first : ''),
                  controller:genderController,
                  items:gender,
                  status: isEdit,
                    lbl: "Select Gender"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateFirstName() {
    if (firstnameController.text.isEmpty) {
      return "First name cannot be empty";
    }
    return null;
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
