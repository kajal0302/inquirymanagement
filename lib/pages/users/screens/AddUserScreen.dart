import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/DynamicStepper.dart';
import 'package:inquirymanagement/components/ImageCamera.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/users/apiCall/UserApi.dart';
import 'package:inquirymanagement/pages/users/components/StepOne.dart';
import 'package:inquirymanagement/pages/users/components/StepTwo.dart';
import 'package:inquirymanagement/pages/users/models/UserModel.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';
import 'package:inquirymanagement/utils/common.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  final Users? user;
  const AddUserScreen({super.key,this.user});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  File? selectedFile;
  String? slug;
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
  String profilePic = userImageUri;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  String title = "Add User";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
    Future.microtask(
      () => Provider.of<BranchProvider>(context, listen: false)
          .getBranch(context),
    );
    if(widget.user != null){
      setData(widget.user!);
    }
  }

  void setData(Users user){
    title = user.name.toString().toUpperCase();
    fullName.text = user.name.toString();
    address.text = user.address.toString();
    mobileNo.text = user.mobileNo.toString();
    emailId.text = user.email.toString();
    designation.text = user.designation.toString();
    birthDate.text = user.dob.toString();
    gender.text = user.gender.toString();
    username.text = user.username.toString();
    password.text = user.pwd.toString();
    confirmPassword.text = user.pwd.toString();
    selectBranch.text = user.branchId.toString();
    joiningDate.text = user.joiningDate.toString();
    userRole.text = user.userType.toString();
    profilePic = user.file ?? userImageUri;
    slug = user.slug.toString();
    setState(() {

    });
  }

  void _onImagePicked(File file) {
    setState(() {
      selectedFile = file;
    });
  }

  List<Map> dynamicSteps(BranchProvider branchProvider,bool isSubmitted) {
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
            gender: gender,
            isSubmitted:isSubmitted
        ),
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
            branchProvider: branchProvider,
            isSubmitted:isSubmitted),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context);
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
                  ImageCamera(
                    image: profilePic,
                    status: true,
                    onImagePicked: _onImagePicked,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: DynamicStepper(
                      dynamicSteps: dynamicSteps(branchProvider,_isSubmitting,),
                      voidCallback: () async {
                        setState(() {
                          _isSubmitting = true;
                        });
                        await Future.delayed(Duration(milliseconds: 50));
                        if(! _formKey.currentState!.validate()){
                          callSnackBar("All Fields Are Required", danger);
                          return;
                        }
                        final data = await postUsers(
                            context,
                            selectedFile,
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
                            slug ?? "");
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
      ),
    );
  }
}
