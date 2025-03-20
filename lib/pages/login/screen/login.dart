import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/components/inputPasswordField.dart';
import 'package:inquirymanagement/components/inputTextField.dart';
import 'package:inquirymanagement/pages/branch/apicall/branchListApi.dart';
import 'package:inquirymanagement/pages/branch/model/branchListModel.dart';
import 'package:inquirymanagement/pages/dashboard/screen/dashboard.dart';
import 'package:inquirymanagement/pages/login/apicall/loginApi.dart';
import 'package:inquirymanagement/pages/login/model/branch.dart';
import 'package:inquirymanagement/utils/asset_paths.dart';
import '../../../common/size.dart';
import '../../../components/button.dart';
import '../../../main.dart';
import '../../../utils/common.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool isLoading = false;
  TextEditingController userName = TextEditingController();
  TextEditingController pswd = TextEditingController();

  @override
  void initState() {
    super.initState();
    // requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Image.asset(
                      loginImage,
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                  SizedBox(
                    height: 240,
                    child: Card(
                      elevation: 4,
                      color: bv_secondaryLightColor3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              TextWidget(
                                label: "Username",
                                labelAlignment: Alignment.topLeft,
                                labelClr: black,
                                labelFontSize: px16,
                                labelFontWeight: FontWeight.normal,
                              ),
                              InputTxt(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: preIconFillColor,
                                  size: px28,
                                ),
                                label: "Username",
                                controller: userName,
                                validator: (value) {
                                  if (_isSubmitting &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter username';
                                  }
                                  return null; // No error
                                },
                              ),
                              TextWidget(
                                label: "Password",
                                labelAlignment: Alignment.topLeft,
                                labelClr: black,
                                labelFontSize: px16,
                                labelFontWeight: FontWeight.normal,
                              ),
                              InputPasswordTxt(
                                label: "Password",
                                password: pswd,
                                validator: (value) {
                                  if (_isSubmitting &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter password';
                                  }
                                  return null; // No error
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: px50,
                      width: 200,
                      child: btnWidget(
                        btnBgColor: bv_primaryDarkColor,
                        btnBrdRadius: BorderRadius.circular(px40),
                        btnLabel: "LOGIN",
                        btnLabelColor: white,
                        btnLabelFontSize: px20,
                        btnLabelFontWeight: FontWeight.bold,
                        onClick: submit,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    loginPageTxt,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bv_primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: px16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Centered Loading Indicator
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: grey_400,
                      strokeWidth: 2.0,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        color: black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // method for login user
  Future<void> submit() async {
    setState(() {
      _isSubmitting = true;
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      String username = userName.text;
      String password = pswd.text;
      String token = '';

      // Simulate API Call
      await Future.delayed(const Duration(seconds: 2));

      var data = await fetchData(username, password, token, context);

      if (data == null || data.status != success) {
        setState(() {
          isLoading = false;
        });
        callSnackBar("No Record Found", danger);
        return;
      } else {
        try {
          if (data.employeeDetail!.userType == adminUserType) {
            BranchListModel? branches = await fetchBranchListData(context);
            if (branches != null && branches.branches!.isNotEmpty) {
              // Get the first branch
              var firstBranch = branches.branches!.first;

              // Store the first branch details
              userBox.put(branchIdStr, firstBranch.id);
              userBox.put(branchNameStr, firstBranch.name);
              userBox.put(branchAddressStr, firstBranch.address);
            }
          } else {
            userBox.put(branchIdStr, data.employeeDetail!.branchId);
          }
          userBox.put(idStr, data.employeeDetail!.id);
          userBox.put(nameStr, data.employeeDetail!.name);
          userBox.put(usernameStr, data.employeeDetail!.username);
          userBox.put(imageStr, data.employeeDetail!.image);
          userBox.put(userTypeStr, data.employeeDetail!.userType);
          userBox.put(statusStr, data.employeeDetail!.status);

          if (data.employeeDetail!.branch != null) {
            // Check if branch is a List<Map<String, dynamic>>
            if (data.employeeDetail!.branch is List<Map<String, dynamic>>) {
              List<Branch> branches = (data.employeeDetail!.branch as List)
                  .map((b) => Branch(
                        id: int.parse(b["id"]),
                        name: b["name"],
                        address: b["address"],
                      ))
                  .toList();
              userBox.put(branchStr, branches);
            }
            // If branch is already a List<Branch>, store it directly
            else if (data.employeeDetail!.branch is List<Branch>) {
              userBox.put(branchStr, data.employeeDetail!.branch);
            }
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
          callSnackBar(data.message.toString(), success);
        } catch (e) {
          print(e);
          callSnackBar('An error occurred: $e', danger);
        } finally {
          if (mounted) {
            setState(() {
              isLoading = false;
              _isSubmitting = false;
            });
          }
        }
      }
    } else {
      setState(() {
        _isSubmitting = false;
        isLoading = false;
      });
    }
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus != AuthorizationStatus.authorized) {
    callSnackBar(
        'User declined or has not accept Notification permission', "def");
  }
}

Future<String> getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  return token ?? "";
}

class TextWidget extends StatelessWidget {
  final Alignment labelAlignment;
  final String label;
  final Color labelClr;
  final FontWeight labelFontWeight;
  final double labelFontSize;

  const TextWidget(
      {super.key,
      required this.labelAlignment,
      required this.label,
      required this.labelClr,
      required this.labelFontWeight,
      required this.labelFontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Align(
        alignment: labelAlignment,
        child: Text(
          label,
          style: TextStyle(
              fontWeight: labelFontWeight,
              fontSize: labelFontSize,
              color: labelClr),
        ),
      ),
    );
  }
}
