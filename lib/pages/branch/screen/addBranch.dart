import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/appBar.dart';
import 'package:inquirymanagement/components/button.dart';
import 'package:inquirymanagement/pages/branch/screen/branch.dart';
import '../../../common/size.dart';
import '../../../components/branchInputField.dart';
class AddBranchPage extends StatefulWidget {
  final bool isEdit;
  final String? branchName;
  final String? branchAddress;
  final String? branchContactNo;
  final String? branchEmail;
  final String? branchLocation;
  const AddBranchPage({super.key, this.isEdit = false,this.branchName,this.branchAddress,this.branchContactNo,this.branchEmail,this.branchLocation});

  @override
  State<AddBranchPage> createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {

  @override
  void initState() {

    // Prefill the value in edit state
    if(widget.isEdit){
      branchName = TextEditingController(text: widget.branchName ?? '');
      branchAddress = TextEditingController(text: widget.branchAddress ?? '');
      branchContact = TextEditingController(text: widget.branchContactNo ?? '');
      branchEmail = TextEditingController(text: widget.branchEmail ?? '');
      branchLocation = TextEditingController(text: widget.branchLocation ?? '');
    }
    super.initState();
  }

  TextEditingController branchName = TextEditingController();
  TextEditingController branchAddress = TextEditingController();
  TextEditingController branchContact = TextEditingController();
  TextEditingController branchEmail = TextEditingController();
  TextEditingController branchLocation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: widgetAppbarForAboutPage(context, widget.isEdit ? "Update Branch" : "Add Branch", BranchPage()),
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
              child: Column(
                children: [
                  SizedBox(height: 5),
                  BranchInputTxt(
                    label: "Branch Name",
                    textColor:  widget.isEdit? bv_primaryDarkColor : black,
                    floatingLabelColor: widget.isEdit? grey_500 : preIconFillColor,
                    controller: branchName,
                  ),
                  BranchInputTxt(
                    label: "Branch Address",
                    textColor:  widget.isEdit? bv_primaryDarkColor : black,
                    floatingLabelColor: widget.isEdit? grey_500 : preIconFillColor,
                    controller: branchAddress,
                    maxLines: 5,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  BranchInputTxt(
                    label: "Branch Mobile No",
                    textColor:  widget.isEdit? bv_primaryDarkColor : black,
                    floatingLabelColor: widget.isEdit? grey_500 : preIconFillColor,
                    controller: branchContact,
                    keyboardType: TextInputType.phone,
                  ),
                  BranchInputTxt(
                    label: "Branch Email",
                    textColor:  widget.isEdit? bv_primaryDarkColor : black,
                    floatingLabelColor: widget.isEdit? grey_500 : preIconFillColor,
                    controller: branchEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  BranchInputTxt(
                    label: "Branch Location",
                    textColor:  widget.isEdit? bv_primaryDarkColor : black,
                    floatingLabelColor: widget.isEdit? grey_500 : preIconFillColor,
                    controller: branchLocation,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: px46,
                      width: 330,
                      child: btnWidget(
                        btnBgColor: bv_primaryDarkColor,
                        btnBrdRadius: BorderRadius.circular(px40),
                        btnLabel: widget.isEdit ? "UPDATE BRANCH" : "SUBMIT BRANCH",
                        btnLabelColor: white,
                        btnLabelFontSize: px18,
                        btnLabelFontWeight: FontWeight.bold,
                        onClick: (){},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
