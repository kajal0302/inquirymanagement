import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/DynamicStepper.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import 'package:inquirymanagement/pages/course/provider/CourseProvider.dart';
import 'package:inquirymanagement/pages/inquiry/apiCall/InquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry/apiCall/PartnerApi.dart';
import 'package:inquirymanagement/pages/inquiry/components/StepOne.dart';
import 'package:inquirymanagement/pages/inquiry/components/StepTwo.dart';
import 'package:inquirymanagement/pages/inquiry/models/PartnerModel.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:provider/provider.dart';

class AddInquiryPage extends StatefulWidget {
  final Inquiries? inquiry;

  const AddInquiryPage({super.key, this.inquiry, required});

  @override
  _AddInquiryPageState createState() => _AddInquiryPageState();
}

class _AddInquiryPageState extends State<AddInquiryPage> {
  String? slug;
  BranchListModel? branchList;
  PartnerModel? partnerModel;
  CourseModel? courseModel;
  late String userId;

  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController reference = TextEditingController();
  TextEditingController feedBack = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController branchSelect = TextEditingController();
  TextEditingController inquiryDate = TextEditingController();
  TextEditingController upcomingInquiryDate = TextEditingController();
  TextEditingController courseIdController = TextEditingController();
  TextEditingController partnerTextEditing = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _isDataLoaded = false; // Track loading state
  String title = "Add Inquiry";

  @override
  void initState() {
    super.initState();
    fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userId = userBox.get(idStr);

      _formKey.currentState?.validate();

      await Future.wait([
        Provider.of<BranchProvider>(context, listen: false).getBranch(context),
        Provider.of<CourseProvider>(context, listen: false).getCourse(context),
      ]);

      if (widget.inquiry != null) {
        title = "Edit Inquiry";
        setData(widget.inquiry!);
      }

      setState(() {
        _isDataLoaded = true; // Mark data as loaded
      });
    });
  }

  Future<void> fetchData() async {
    partnerModel = await fetchPartner(context);
    setState(() {});
  }

  void setData(Inquiries inquiryDetail) {
    fname.text = inquiryDetail.fname.toString();
    lname.text = inquiryDetail.lname.toString();
    mobileNo.text = inquiryDetail.contact.toString();
    emailId.text = inquiryDetail.email.toString();
    reference.text = inquiryDetail.reference.toString();
    feedBack.text = inquiryDetail.feedback.toString();
    // courseController.text = courseName.join(", ");
    branchSelect.text = inquiryDetail.branchId.toString();
    inquiryDate.text = inquiryDetail.inquiryDate.toString();
    upcomingInquiryDate.text = inquiryDetail.upcomingConfirmDate.toString();
  }

  List<Map> dynamicSteps(BranchProvider branchProvider, bool isSubmitted,
      CourseModel _courseModel) {
    return [
      {
        "title": "Personal Details",
        "content": StepOne(
            fname: fname,
            lname: lname,
            mobileNo: mobileNo,
            emailId: emailId,
            reference: reference,
            feedback: feedBack,
            partnerModel: partnerModel,
            partner: partnerTextEditing,
            isSubmitted: isSubmitted)
      },
      {
        "title": "User Account Details",
        "content": StepTwo(
          inquiry: widget.inquiry,
          courses: _courseModel,
          courseController: courseController,
          selectBranch: branchSelect,
          inquiryDate: inquiryDate,
          upcomingInquiryDate: upcomingInquiryDate,
          branchProvider: branchProvider,
          isSubmitted: isSubmitted,
          onCourseSelectionChange: (CourseModel updatedCourses) {
            courseModel = updatedCourses;
            setState(() {});
          },
        )
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context);
    final courseProvider = context.watch<CourseProvider>();
    courseModel = courseProvider.course;

    if (!_isDataLoaded) {
      return Scaffold(
        appBar: buildAppBar(context, title, []),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: buildAppBar(context, title, []),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: DynamicStepper(
                      dynamicSteps: dynamicSteps(
                          branchProvider, _isSubmitting, courseModel!),
                      voidCallback: () async {
                        setState(() {
                          _isSubmitting = true;
                        });
                        await Future.delayed(const Duration(milliseconds: 50));
                        if (!_formKey.currentState!.validate()) {
                          callSnackBar("All Fields Are Required", danger);
                          return;
                        }
                        List<String> courseList = [];
                        courseModel!.courses!.forEach((e) {
                          if (e.isChecked ?? false) {
                            courseList.add(e.id.toString());
                          }
                        });
                        var response;
                          response = await postInquiries(
                              context,
                              widget.inquiry != null ? widget.inquiry!.slug : null,
                              fname.text,
                              lname.text,
                              emailId.text,
                              branchSelect.text,
                              feedBack.text,
                              reference.text,
                              mobileNo.text,
                              partnerTextEditing.text,
                              courseList.join(","),
                              "0",
                              "0",
                              inquiryDate.text,
                              upcomingInquiryDate.text,
                              "1",
                              userId);
                        if (response == null) {
                          callSnackBar("Unknown Error Accrued", danger);
                          return;
                        }

                        callSnackBar(
                            response.message ?? "Unknown Error Accrued",
                            response.status ?? "def");

                        if (response.status == success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InquiryReportPage(),
                            ),
                          );
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
      ),
    );
  }
}
