import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/DynamicStepper.dart';
import 'package:inquirymanagement/components/ImageCamera.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/course/provider/CourseProvider.dart';
import 'package:inquirymanagement/pages/inquiry/apiCall/InquiryApi.dart';
import 'package:inquirymanagement/pages/inquiry/apiCall/PartnerApi.dart';
import 'package:inquirymanagement/pages/inquiry/apiCall/inquiryDetailApi.dart';
import 'package:inquirymanagement/pages/inquiry/components/StepOne.dart';
import 'package:inquirymanagement/pages/inquiry/components/StepTwo.dart';
import 'package:inquirymanagement/pages/inquiry/models/PartnerModel.dart';
import 'package:inquirymanagement/pages/inquiry/models/inquiryModel.dart';
import 'package:inquirymanagement/pages/inquiry_report/screen/inquiryReport.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../components/branchInputField.dart';

class AddInquiryPage extends StatefulWidget {
  final bool isEdit;
  final String? id;

  const AddInquiryPage({super.key, this.isEdit = false, this.id});

  @override
  State<AddInquiryPage> createState() => _AddInquiryPageState();
}

class _AddInquiryPageState extends State<AddInquiryPage> {
  String? slug;
  File? selectedFile;
  BranchListModel? branchList;
  PartnerModel? partnerModel;
  late String userId;
  InquiryModel? inquiryDetailData;

  final TextEditingController firstNameTextEditing = TextEditingController();
  final TextEditingController lastNameTextEditing = TextEditingController();
  final TextEditingController mobileNoTextEditing = TextEditingController();
  final TextEditingController referenceByTextEditing = TextEditingController();
  final TextEditingController feedBackTextEditing = TextEditingController();
  final TextEditingController coursesTextEditing = TextEditingController();
  final TextEditingController coursesIdsTextEditing = TextEditingController();
  final TextEditingController branchTextEditing = TextEditingController();
  final TextEditingController inquiryDateTextEditing = TextEditingController();
  final TextEditingController upcomingTextEditing = TextEditingController();
  final TextEditingController smsTextEditing = TextEditingController();
  final TextEditingController partnerTextEditing = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool isLoading = true;
  String profilePic = userImageUri;

  @override
  void initState() {
    super.initState();
    fetchData();
    userId = userBox.get(idStr);
    Future.microtask(() {
      Provider.of<BranchProvider>(context, listen: false).getBranch(context);
      Provider.of<CourseProvider>(context, listen: false).getCourse(context);
    });

    if (widget.isEdit && widget.id!.isNotEmpty) {
      loadInquiryDetailData();
    }

    if (widget.isEdit) {
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      isLoading = false;
    }
  }

  /// Method to fetch Inquiry Detail
  Future<void> loadInquiryDetailData() async {
    InquiryModel? inquiryDetail =
        await fetchInquiryDetailData(context, widget.id!);
    if (mounted) {
      inquiryDetailData = inquiryDetail;

      /// Prefill  Data
      if (inquiryDetailData != null &&
          inquiryDetailData!.inquiryDetail != null) {
        firstNameTextEditing.text =
            inquiryDetailData!.inquiryDetail!.fname ?? '';
        lastNameTextEditing.text =
            inquiryDetailData!.inquiryDetail!.lname ?? '';
        mobileNoTextEditing.text =
            inquiryDetailData!.inquiryDetail!.mobileno ?? '';
        referenceByTextEditing.text =
            inquiryDetailData?.inquiryDetail?.reference ?? '';
        feedBackTextEditing.text =
            inquiryDetailData!.inquiryDetail!.feedback ?? '';
        if (inquiryDetailData?.inquiryDetail?.courses != null &&
            inquiryDetailData!.inquiryDetail!.courses!.isNotEmpty) {
          coursesTextEditing.text = inquiryDetailData!.inquiryDetail!.courses!
              .map((course) => course.name)
              .join(', ');
          String courseIds = inquiryDetailData!.inquiryDetail!.courses!
              .map((course) => course.id.toString().trim())
              .join(', ');

          coursesIdsTextEditing.value = TextEditingValue(
            text: courseIds,
            selection: TextSelection.collapsed(offset: courseIds.length),
          );
        } else {
          coursesTextEditing.text = '';
          coursesIdsTextEditing.text = '';
        }
        branchTextEditing.text =
            inquiryDetailData!.inquiryDetail!.branchName ?? '';
        String formattedDate = DateFormat('yyyy-MM-dd').format(
            DateFormat('dd/MM/yyyy')
                .parse(inquiryDetailData!.inquiryDetail!.inquiyDate!));
        inquiryDateTextEditing.text = formattedDate ?? '';
        upcomingTextEditing.text =
            inquiryDetailData!.inquiryDetail!.upcomingConfirmDate ?? '';
        smsTextEditing.text =
            inquiryDetailData!.inquiryDetail!.smsContent ?? '';
        partnerTextEditing.text =
            inquiryDetailData!.inquiryDetail!.partnerId ?? '';
      }
      setState(() {});
    }
  }

  Future<void> fetchData() async {
    partnerModel = await fetchPartner(context);
  }

  void _onImagePicked(File file) {
    setState(() {
      selectedFile = file;
    });
  }

  List<Map<String, dynamic>> dynamicSteps(BranchProvider branchProvider,
      bool isSubmitted, CourseProvider courseProvider) {
    return [
      {
        "title": "Personal Details",
        "content": (widget.isEdit && isLoading)
            ? _buildLoadingForm()
            : StepOne(
                firstName: firstNameTextEditing,
                lastName: lastNameTextEditing,
                mobileNo: mobileNoTextEditing,
                feedback: feedBackTextEditing,
                reference: referenceByTextEditing,
                partner: partnerTextEditing,
                partnerModel: partnerModel,
                isSubmitted: isSubmitted,
              ),
      },
      {
        "title": "Inquiry Details",
        "content": StepTwo(
          course: coursesTextEditing,
          coursesId: coursesIdsTextEditing,
          branch: branchTextEditing,
          inquiryDate: inquiryDateTextEditing,
          selectBranch: branchTextEditing,
          upcomingDate: upcomingTextEditing,
          smsType: smsTextEditing,
          branchProvider: branchProvider,
          isSubmitted: isSubmitted,
          courses: courseProvider.course,
        ),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = context.watch<BranchProvider>();
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: buildAppBar(
          context,
          widget.isEdit && inquiryDetailData != null
              ? '${inquiryDetailData!.inquiryDetail!.fname ?? ''} ${inquiryDetailData!.inquiryDetail!.lname ?? ''}'
              : "Inquiry Form",
          []),
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
                  // ImageCamera(
                  //   image: profilePic,
                  //   status: true,
                  //   onImagePicked: _onImagePicked,
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: DynamicStepper(
                      dynamicSteps: dynamicSteps(
                          branchProvider, _isSubmitting, courseProvider),
                      voidCallback: () async {
                        setState(() {
                          _isSubmitting = true;
                        });

                        await Future.delayed(const Duration(milliseconds: 50));

                        // print("--------------");
                        // print(coursesIdsTextEditing.text);
                        // return;
                        if (!_formKey.currentState!.validate()) {
                          callSnackBar("All Fields Are Required", danger);
                          return;
                        }
                        var response;
                        if (widget.isEdit && widget.id!.isNotEmpty) {
                          response = await postInquiries(
                              context,
                              inquiryDetailData!.inquiryDetail!.slug,
                              firstNameTextEditing.text,
                              lastNameTextEditing.text,
                              branchTextEditing.text,
                              feedBackTextEditing.text,
                              referenceByTextEditing.text,
                              mobileNoTextEditing.text,
                              partnerTextEditing.text,
                              coursesIdsTextEditing.text,
                              "0",
                              "0",
                              inquiryDateTextEditing.text,
                              upcomingTextEditing.text,
                              "1",
                              userId);
                        } else {
                          response = await postInquiries(
                              context,
                              null,
                              firstNameTextEditing.text,
                              lastNameTextEditing.text,
                              branchTextEditing.text,
                              feedBackTextEditing.text,
                              referenceByTextEditing.text,
                              mobileNoTextEditing.text,
                              partnerTextEditing.text,
                              coursesIdsTextEditing.text,
                              "0",
                              "0",
                              inquiryDateTextEditing.text,
                              upcomingTextEditing.text,
                              "1",
                              userId);
                        }
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

/// Widget for Personal Detail Form (Step One) which is used while inquiry Data is loading
Widget _buildLoadingForm() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDisabledBranchInput("First Name"),
        buildDisabledBranchInput("Last Name"),
        buildDisabledBranchInput("Mobile Number"),
        buildDisabledBranchInput("Select Reference"),
        buildDisabledBranchInput("Feedback"),
      ],
    ),
  );
}

Widget buildDisabledBranchInput(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: BranchInputTxt(
      label: label,
      textColor: Colors.grey,
      floatingLabelColor: Colors.grey,
      controller: TextEditingController(),
      readOnly: true,
      keyboardType: TextInputType.text,
    ),
  );
}
