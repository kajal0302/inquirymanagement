import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/students/apicall/addStudentApi.dart';
import 'package:inquirymanagement/pages/students/apicall/batchListApi.dart';
import 'package:inquirymanagement/pages/students/models/batchListModel.dart';
import 'package:inquirymanagement/pages/students/models/partnerListModel.dart';
import 'package:inquirymanagement/pages/students/provider/branchProvider.dart';
import 'package:inquirymanagement/pages/students/provider/categoryProvider.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:provider/provider.dart';
import '../../../common/text.dart';
import '../../../components/DynamicStepper.dart';
import '../../../utils/common.dart';
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
  bool isLoading=true;
  bool isCourseSelected= false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        await Provider.of<CategoryProvider>(context, listen: false).getCategory(context);
        await Provider.of<StudentBranchProvider>(context, listen: false).getBranch(context);
        loadstudentBatchListData();
        loadstudentPartnerListData();
      });
    });
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
          onCourseSelected: (bool selected) {
            setState(() {
              isCourseSelected = selected;
            });
          },
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
        )
      },
    ];
  }


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
                    enforceCourseSelection: true,
                    voidCallback: () async{
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
                      if (invalidForms.isEmpty) {

                        var data = await createStudentData(
                            context,
                            userBox.get('id').toString(),
                            firstnameController.text,
                            lastnameController.text,
                            mobileController.text,
                            whatsappController.text,
                            emailController.text,
                            birthController.text,
                            genderController.text,
                            branchController.text,
                            usernameController.text,
                            passwordController.text,
                            parentNameController.text,
                            parentMobileController.text,
                            parentAddressController.text,
                            batchController.text,
                            categoryController.text,
                            courseController.text,
                            discountController.text,
                            joiningDateController.text,
                            referenceByController.text, partnerController.text
                        );

                        // Handle the response from the submission
                        if (data?.status == success) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InquiryReportPage()));
                          callSnackBar(data!.message.toString(), success);
                        } else {
                          callSnackBar(data!.message.toString(), "danger");
                        }
                      }  else {
                        String errorMessage = "Please fix errors in the following forms: ${invalidForms.join(', ')}";
                        callSnackBar(errorMessage, "danger");
                      }
                  },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

