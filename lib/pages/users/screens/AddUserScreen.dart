import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/DynamicStepper.dart';
import 'package:inquirymanagement/components/ImageCamera.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/branch/apicall/branchListApi.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/users/apiCall/UserApi.dart';
import 'package:inquirymanagement/pages/users/components/StepOne.dart';
import 'package:inquirymanagement/pages/users/components/StepTwo.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  File? selectedFile;
  BranchListModel? branchList;
  TextEditingController fullName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController selectBranch = TextEditingController();
  TextEditingController joiningDate = TextEditingController();
  TextEditingController userRole = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<BranchProvider>(context, listen: false)
          .getBranch(context),
    ); 
  }

  void _onImagePicked(File file) {
    setState(() {
      selectedFile = file;
    });
  }

  List<Map> dynamicSteps(BranchProvider branchProvider) {
    return [
      {
        "title": "Personal Details",
        "content": StepOne(
            fullName: fullName,
            address: address,
            mobileNo: mobileNo,
            emailId: emailId,
            designation: designation,
            birthDate: birthDate,
            gender: gender),
      },
      {
        "title": "User Account Details",
        "content": StepTwo(
            username: username,
            password: password,
            confirmPassword: confirmPassword,
            selectBranch: selectBranch,
            joiningDate: joiningDate,
            userRole: userRole,
            branchProvider: branchProvider),
      },
    ];
  }

  String profilePic = userImageUri;

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context);
    return Scaffold(
      appBar: buildAppBar(context, "Add User", []),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Column(
              children: [
                ImageCamera(
                  image: profilePic,
                  status: true,
                  onImagePicked: _onImagePicked,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: DynamicStepper(
                    dynamicSteps: dynamicSteps(branchProvider),
                    voidCallback: () async {
                      final data = await postUsers(
                          context,
                          fullName.text,
                          address.text,
                          mobileNo.text,
                          emailId.text,
                          designation.text,
                          birthDate.text,
                          gender.text,
                          username.text,
                          password.text,
                          selectBranch.text,
                          joiningDate.text,
                          userRole.text,
                          "1",
                          "",
                          selectedFile);
                      if (data == null) {
                        callSnackBar("Unknown Error Accrued", danger);
                        return;
                      }

                      callSnackBar(data.message ?? "Unknown Error Accrued", data.status ?? "def");
                      if (data.status == success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(),
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
    );
  }
}
