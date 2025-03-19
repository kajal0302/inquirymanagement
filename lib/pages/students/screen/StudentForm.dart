import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/students/apicall/addStudentApi.dart';
import 'package:inquirymanagement/pages/students/apicall/batchListApi.dart';
import 'package:inquirymanagement/pages/students/models/batchListModel.dart';
import 'package:inquirymanagement/pages/students/provider/branchProvider.dart';
import 'package:inquirymanagement/pages/students/provider/categoryProvider.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import 'package:provider/provider.dart';
import '../../../common/text.dart';
import '../../../components/DynamicStepper.dart';
import '../../../utils/common.dart';
import '../../inquiry/apiCall/PartnerApi.dart';
import '../../inquiry/models/PartnerModel.dart';
import '../apicall/courseListApi.dart';
import '../components/courseDetails.dart';
import '../components/createUsernamePassword.dart';
import '../components/installmentDetails.dart';
import '../components/parentDetails.dart';
import '../components/personalDetails.dart';
import '../models/courseListModel.dart';


final _personalDetailsFormKey = GlobalKey<FormState>();
final _usernamePasswordFormKey = GlobalKey<FormState>();
final _parentsDetailsFormKey = GlobalKey<FormState>();
final _courseDetailsFormKey = GlobalKey<FormState>();
final _installmentDetailsFormKey = GlobalKey<FormState>();
List<String> batchItems = [];
List<String> batchIds = [];
String? categoryId;
PartnerModel? partnerModel;
bool _isSubmitting = false;

class StudentForm extends StatefulWidget {
  final String? id;
  final String? fname;
  final String? lname;
  final String? contact;

  const StudentForm({super.key, this.id, this.fname,this.lname,this.contact});

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
      if(widget.id!.isNotEmpty)
        {
          firstnameController.text=widget.fname ?? '';
          lastnameController.text = widget.lname ?? '';
          mobileController.text=widget.contact ?? '';

        }
      Future.microtask(() async {
        await Provider.of<StudentBranchProvider>(context, listen: false).getBranch(context);
        final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
        await categoryProvider.getCategory(context);

        if (categoryProvider.category != null &&
            categoryProvider.category!.categories != null &&
            categoryProvider.category!.categories!.isNotEmpty) {
          setState(() {
            categoryId = categoryProvider.category!.categories!.first.id.toString();
          });
        }
        await loadstudentCourseListData();
        loadstudentBatchListData();
        fetchData();
      });
    });
  }



  /// Method to load BatchList
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

  /// Method to load PartnerList
  Future<void> fetchData() async{
    partnerModel =
    await fetchPartner(context);
    setState(() {
    });
  }


  /// Load Course List Data
  Future<void> loadstudentCourseListData() async {
    StudentCourseListModel? fetchedCourseListData = await fetchStudentCourseListData(context,categoryId.toString());
    setState(() {
      if (fetchedCourseListData != null &&
          fetchedCourseListData.courses != null &&
          fetchedCourseListData.courses!.isNotEmpty) {
        courseItemsWithFee = fetchedCourseListData.courses!.map((item) => {
          "id": item.id.toString(),
          "value": item.name ?? '',
          "total_fee": int.tryParse(item.fees ?? '0') ?? 0,
        }).toList();
      } else {
        courseItems = [];
      }
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
          isSubmitted: _isSubmitting,
        )
      },
      {
        "title": "Installment Details",
        "content": InstallmentDetails(
          formKey: _installmentDetailsFormKey,
          partnerModel:partnerModel,
          discountController: discountController,
          installmentTypeController: installmentTypeController,
          joiningDateController: joiningDateController,
          referenceByController:referenceByController,
          partnerController:partnerController,
          isSubmitted: _isSubmitting,
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
      appBar: customPageAppBar(context, "${widget.fname ?? ''} ${widget.lname ?? ''}", InquiryReportPage()),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(userImg),
              ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child:
                  DynamicStepper(
                    dynamicSteps: dynamicSteps(branchProvider,categoryProvider,_isSubmitting,),
                    enforceCourseSelection: true,
                    voidCallback: () async{

                      setState(() {
                        _isSubmitting = true;
                      });

                      await Future.delayed(const Duration(milliseconds: 50));
                      bool isPersonalDetailsFormValid = _personalDetailsFormKey.currentState!.validate();
                      bool isUsernamePasswordFormValid = _usernamePasswordFormKey.currentState!.validate() ;
                      bool isParentsDetailsFormValid = _parentsDetailsFormKey.currentState!.validate();
                      bool isCourseDetailsFormValid = _courseDetailsFormKey.currentState!.validate();
                      bool isInstallmentDetailsFormValid = _installmentDetailsFormKey.currentState!.validate();
                      print(isPersonalDetailsFormValid);
                      print(isUsernamePasswordFormValid);
                      print(isParentsDetailsFormValid);
                      print(isCourseDetailsFormValid);
                      print(isInstallmentDetailsFormValid);


                      /// Message according to forms
                      List<String> invalidForms = [];

                      if (!isPersonalDetailsFormValid) invalidForms.add("Personal Details Form");
                      if (!isUsernamePasswordFormValid) invalidForms.add("Username & Password Form");
                      if (!isParentsDetailsFormValid) invalidForms.add("Parents Details Form");
                      if (!isCourseDetailsFormValid) invalidForms.add("Course Details Form");
                      if (!isInstallmentDetailsFormValid) invalidForms.add("Installment Details Form");

                      /// Proceed only if all forms are valid
                      if (invalidForms.isEmpty) {

                        String selectedBatchIdsString = selectedBatchIds.join(",");
                        String selectedCourseIdsString = courseIds.join(",");

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
                            selectedBatchIdsString,
                            categoryController.text,
                            selectedCourseIdsString,
                            discountController.text.isNotEmpty ? discountController.text : "0",
                            joiningDateController.text,
                            referenceByController.text,
                            partnerController.text
                        );

                        if (data != null && data.status == success) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InquiryReportPage()));
                          callSnackBar(data.message.toString(), success);
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

