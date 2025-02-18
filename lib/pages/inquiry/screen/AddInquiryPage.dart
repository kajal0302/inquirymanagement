import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/DynamicStepper.dart';
import 'package:inquirymanagement/components/ImageCamera.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/course/provider/CourseProvider.dart';
import 'package:inquirymanagement/pages/inquiry/components/StepOne.dart';
import 'package:inquirymanagement/pages/inquiry/components/StepTwo.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:provider/provider.dart';

class AddInquiryPage extends StatefulWidget {
  const AddInquiryPage({super.key});

  @override
  State<AddInquiryPage> createState() => _AddInquiryPageState();
}

class _AddInquiryPageState extends State<AddInquiryPage> {
  String? slug;
  File? selectedFile;
  BranchListModel? branchList;

  final TextEditingController firstNameTextEditing = TextEditingController();
  final TextEditingController lastNameTextEditing = TextEditingController();
  final TextEditingController mobileNoTextEditing = TextEditingController();
  final TextEditingController referenceByTextEditing = TextEditingController();
  final TextEditingController feedBackTextEditing = TextEditingController();
  final TextEditingController coursesTextEditing = TextEditingController();
  final TextEditingController branchTextEditing = TextEditingController();
  final TextEditingController inquiryDateTextEditing = TextEditingController();
  final TextEditingController upcomingTextEditing = TextEditingController();
  final TextEditingController smsTextEditing = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String profilePic = userImageUri;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BranchProvider>(context, listen: false).getBranch(context);
      Provider.of<CourseProvider>(context, listen: false).getCourse(context);
    });
  }

  void _onImagePicked(File file) {
    setState(() {
      selectedFile = file;
    });
  }

  List<Map<String, dynamic>> dynamicSteps(
      BranchProvider branchProvider, bool isSubmitted, CourseProvider courseProvider) {
    return [
      {
        "title": "Personal Details",
        "content": StepOne(
          firstName: firstNameTextEditing,
          lastName: lastNameTextEditing,
          mobileNo: mobileNoTextEditing,
          feedback: feedBackTextEditing,
          reference: referenceByTextEditing,
          isSubmitted: isSubmitted,
        ),
      },
      {
        "title": "Inquiry Details",
        "content": StepTwo(
          course: coursesTextEditing,
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
      appBar: buildAppBar(context, "Inquiry Form", []),
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
                  ImageCamera(
                    image: profilePic,
                    status: true,
                    onImagePicked: _onImagePicked,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: DynamicStepper(
                      dynamicSteps: dynamicSteps(branchProvider, _isSubmitting, courseProvider),
                      voidCallback: () async {
                        if (!_formKey.currentState!.validate()) {
                          callSnackBar("All Fields Are Required", danger);
                          return;
                        }

                        setState(() {
                          _isSubmitting = true;
                        });

                        await Future.delayed(const Duration(milliseconds: 50));

                        // Add form submission logic here
                        // Example:
                        // var response = await submitForm();
                        // handleResponse(response);
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
