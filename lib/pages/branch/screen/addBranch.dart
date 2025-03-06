import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/components/button.dart';
import 'package:inquirymanagement/main.dart';
import 'package:inquirymanagement/pages/branch/apicall/addBranchApi.dart';
import 'package:inquirymanagement/pages/branch/screen/branch.dart';
import '../../../common/size.dart';
import '../../../common/text.dart';
import '../../../components/branchInputField.dart';
import '../../../utils/common.dart';

class AddBranchPage extends StatefulWidget {
  final bool isEdit;
  final String? branchName,
      branchAddress,
      branchContactNo,
      branchEmail,
      branchLocation,
      slug;

  const AddBranchPage(
      {super.key,
      this.isEdit = false,
      this.branchName,
      this.branchAddress,
      this.branchContactNo,
      this.branchEmail,
      this.branchLocation,
      this.slug});

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  String createdBy = userBox.get(idStr).toString();
  final _formKey = GlobalKey<FormState>();/// Create a GlobalKey for form validation
  bool _isSubmitting = false;
  bool isLoading = false;

  TextEditingController branchName = TextEditingController();
  TextEditingController branchAddress = TextEditingController();
  TextEditingController branchContact = TextEditingController();
  TextEditingController branchEmail = TextEditingController();
  TextEditingController branchLocation = TextEditingController();

  @override
  void initState() {
    /// Prefill the values in Edit state
    if (widget.isEdit) {
      branchName = TextEditingController(text: widget.branchName ?? '');
      branchAddress = TextEditingController(text: widget.branchAddress ?? '');
      branchContact = TextEditingController(text: widget.branchContactNo ?? '');
      branchEmail = TextEditingController(text: widget.branchEmail ?? '');
      branchLocation = TextEditingController(text: widget.branchLocation ?? '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForAboutPage(context,
          widget.isEdit ? "Update Branch" : "Add Branch", BranchPage()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
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
                    BranchInputTxt(
                      label: "Branch Name",
                      textColor: widget.isEdit ? bv_primaryDarkColor : black,
                      floatingLabelColor:
                          widget.isEdit ? grey_500 : preIconFillColor,
                      controller: branchName,
                      validator: (value) {
                        if (_isSubmitting && (value == null || value.isEmpty)) {
                          return 'Please enter branch name';
                        }
                        return null; // No error
                      },
                    ),
                    BranchInputTxt(
                      label: "Branch Address",
                      textColor: widget.isEdit ? bv_primaryDarkColor : black,
                      floatingLabelColor:
                          widget.isEdit ? grey_500 : preIconFillColor,
                      controller: branchAddress,
                      maxLines: 5,
                      keyboardType: TextInputType.streetAddress,
                      validator: (value) {
                        if (_isSubmitting && (value == null || value.isEmpty)) {
                          return 'Please enter branch address';
                        }
                        return null; // No error
                      },
                    ),
                    BranchInputTxt(
                      label: "Branch Mobile No",
                      textColor: widget.isEdit ? bv_primaryDarkColor : black,
                      floatingLabelColor:
                          widget.isEdit ? grey_500 : preIconFillColor,
                      controller: branchContact,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (_isSubmitting) {
                          String trimmedValue = value?.trim() ?? "";

                          if (trimmedValue.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          if (trimmedValue.length != 10) {
                            return 'Mobile number must be exactly 10 digits';
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(trimmedValue)) {
                            return 'Please enter a valid numeric mobile number';
                          }
                        }
                        return null; // No error
                      },
                    ),
                    BranchInputTxt(
                      label: "Branch Email",
                      textColor: widget.isEdit ? bv_primaryDarkColor : black,
                      floatingLabelColor:
                          widget.isEdit ? grey_500 : preIconFillColor,
                      controller: branchEmail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (_isSubmitting) {
                          String trimmedValue = value?.trim() ?? "";
                          if (trimmedValue.isEmpty) {
                            return 'Please enter branch email';
                          }
                          // Regular expression for validating an email
                          if (!RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(trimmedValue)) {
                            return 'Please enter a valid email address';
                          }
                        }
                        return null; // No error
                      },
                    ),
                    BranchInputTxt(
                      label: "Branch Location",
                      textColor: widget.isEdit ? bv_primaryDarkColor : black,
                      floatingLabelColor:
                          widget.isEdit ? grey_500 : preIconFillColor,
                      controller: branchLocation,
                      validator: (value) {
                        if (_isSubmitting && (value == null || value.isEmpty)) {
                          return 'Please enter branch location';
                        }
                        return null; // No error
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: px46,
                        width: 330,
                        child: btnWidget(
                          btnBgColor: bv_primaryDarkColor,
                          btnBrdRadius: BorderRadius.circular(px40),
                          btnLabel:
                              widget.isEdit ? "UPDATE BRANCH" : "SUBMIT BRANCH",
                          btnLabelColor: white,
                          btnLabelFontSize: px18,
                          btnLabelFontWeight: FontWeight.bold,
                          onClick: submit,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Method for Add Branch
  Future<void> submit() async {
    setState(() {
      _isSubmitting = true;
      isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      String branchname = branchName.text;
      String address = branchAddress.text;
      String mobileno = branchContact.text;
      String email = branchEmail.text;
      String location = branchLocation.text;

      var data;

      if (widget.isEdit && widget.slug != null) {
        data = await createBranchData(branchname, address, mobileno, email,
            location, createdBy, widget.slug, context);
      } else {
        data = await createBranchData(branchname, address, mobileno, email,
            location, createdBy, null, context);
      }

      if (data == null || data.status != success) {
        setState(() {
          isLoading = false;
        });
        callSnackBar("Error in Adding Data", "danger");
        return;
      } else {
        try {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BranchPage()),
          );
          callSnackBar(data.message.toString(), "success");
        } catch (e) {
          callSnackBar('An error occurred: $e', "error");
        } finally {
          if (mounted) {
            setState(() {
              isLoading = false; // Stop loading indicator in all cases
              _isSubmitting = false;
            });
          }
        }
      }
    } else {
      // Validation failed, stop loading indicator
      setState(() {
        _isSubmitting = false;
        isLoading = false; // Ensure isLoading is false if validation fails
      });
    }
  }
}
