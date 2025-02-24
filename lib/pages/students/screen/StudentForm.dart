import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/students/apicall/batchListApi.dart';
import 'package:inquirymanagement/pages/students/models/batchListModel.dart';
import 'package:inquirymanagement/pages/students/models/courseListModel.dart';
import 'package:inquirymanagement/pages/students/models/partnerListModel.dart';
import 'package:inquirymanagement/pages/students/provider/branchProvider.dart';
import 'package:inquirymanagement/pages/students/provider/categoryProvider.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:provider/provider.dart';
import '../../../components/DynamicStepper.dart';
import '../../../components/buttonField.dart';
import '../apicall/courseListApi.dart';
import '../apicall/partnerListModel.dart';
import '../components/courseDetails.dart';
import '../components/createUsernamePassword.dart';
import '../components/installmentDetails.dart';
import '../components/parentDetails.dart';
import '../components/personalDetails.dart';

bool _isSubmitting = false;
final _personalDetailsFormKey = GlobalKey<FormState>();
final _usernamePasswordFormKey = GlobalKey<FormState>();
final _parentsDetailsFormKey = GlobalKey<FormState>();
final _courseDetailsFormKey = GlobalKey<FormState>();
final _installmentDetailsFormKey = GlobalKey<FormState>();

List<String> batchItems = [];
List batchIds = [];
List<String> selectedBatchItems = [];
List<String> courseItem = [];
List<Map<String, dynamic>> courseItems = [];
List courseIds = [];
List<String> partnerItems = [];
List partnerIds = [];
String? categoryId;


class StudentForm extends StatefulWidget {
  final String? id;
  final String? fname;
  final String? lname;

  const StudentForm({super.key, this.id, this.fname,this.lname});

  @override
  State<StudentForm> createState() => _StudentFromState();
}

class _StudentFromState extends State<StudentForm> {
  bool isEdit = true;
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
    Future.microtask(() async {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

      await Provider.of<StudentBranchProvider>(context, listen: false).getBranch(context);
      await categoryProvider.getCategory(context);

      if (categoryProvider.category != null &&
          categoryProvider.category!.categories != null &&
          categoryProvider.category!.categories!.isNotEmpty) {
        categoryId = categoryProvider.category!.categories!.first.id.toString();
        await loadstudentCourseListData();
      }

    });
    loadstudentBatchListData();
    loadstudentPartnerListData();

  }



  // Method to load BatchList
  Future<void> loadstudentBatchListData() async {
    StudentBatchListModel? fetchedBatchListData = await fetchStudentBatchListData(context);
    setState(() {
      if (fetchedBatchListData != null && fetchedBatchListData.batches != null &&
          fetchedBatchListData.batches!.isNotEmpty)
      {
        batchItems =
            fetchedBatchListData.batches!.map((item) => item.name ?? '').toList();
        batchIds = fetchedBatchListData.batches!
            .map((item) => item.id.toString() ?? '')
            .toList();

      } else
      {
        batchItems = [];
      }
      isLoading = false;
    });
  }


  // Method to load Course List Data
  Future<void> loadstudentCourseListData() async {
    StudentCourseListModel? fetchedCourseListData = await fetchStudentCourseListData(context,categoryId.toString());
    setState(() {
      if (fetchedCourseListData != null && fetchedCourseListData.courses != null &&
          fetchedCourseListData.courses!.isNotEmpty)
      {
        courseItems = fetchedCourseListData.courses!.map((item) => {
          "id": item.id.toString(),
          "value": item.name ?? '',
        }).toList();

        courseIds = fetchedCourseListData.courses!
            .map((item) => item.id.toString() ?? '')
            .toList();

      } else
      {
        courseItems = [];
      }
    });
  }


  // Method to load PartnerList
  Future<void> loadstudentPartnerListData() async {
    StudentPartnerListModel? fetchedPartnerListData = await fetchPartnerListData(context);
    setState(() {
      if (fetchedPartnerListData != null && fetchedPartnerListData.partners != null &&
          fetchedPartnerListData.partners!.isNotEmpty)
      {
        partnerItems =
            fetchedPartnerListData.partners!.map((item) => item.partnerName ?? '').toList();
        partnerIds = fetchedPartnerListData.partners!
            .map((item) => item.id.toString() ?? '')
            .toList();

      } else
      {
        partnerItems = [];
      }
      isLoading = false;
    });
  }





  List<Map> dynamicSteps(StudentBranchProvider branchProvider,CategoryProvider categoryProvider, bool isSubmitted) {
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
          studentBranchProvider: branchProvider,
          isEdit: isEdit,
          isSubmitted: _isSubmitting,
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
          isSubmitted: _isSubmitting,

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
          isSubmitted: _isSubmitting,
        )
      },
      {
        "title": "Course Details",
        "content": CourseDetails(
          formKey: _courseDetailsFormKey,
          batchController: batchController,
          categoryController: categoryController,
          courseController: courseController,
          categoryProvider: categoryProvider,
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
    final branchProvider = Provider.of<StudentBranchProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
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
                  child: DynamicStepper(
                    dynamicSteps: dynamicSteps(branchProvider,categoryProvider,_isSubmitting,),
                    voidCallback: () {

                    },),
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
            btnWidth: 300,
            onClick: () async {
              setState(() {
                _isSubmitting = true;
              });
              bool isPersonalDetailsFormValid = _personalDetailsFormKey.currentState!.validate();
              bool isUsernamePasswordFormValid = _usernamePasswordFormKey.currentState!.validate() ;
              bool isParentsDetailsFormValid = _parentsDetailsFormKey.currentState!.validate();
              bool isCourseDetailsFormValid = _courseDetailsFormKey.currentState?.validate() ?? false;
              bool isInstallmentDetailsFormValid = _installmentDetailsFormKey.currentState?.validate() ?? false;

              //Message according to forms
              List<String> invalidForms = [];

              if (!isPersonalDetailsFormValid) invalidForms.add("Personal Details Form");
              if (!isUsernamePasswordFormValid) invalidForms.add("Username & Password Form");
              if (!isParentsDetailsFormValid) invalidForms.add("Parents Details Form");
              if (!isCourseDetailsFormValid) invalidForms.add("Course Details Form");
              if (!isInstallmentDetailsFormValid) invalidForms.add("Installment Details Form");

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
