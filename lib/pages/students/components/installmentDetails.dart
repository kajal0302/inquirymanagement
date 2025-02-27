import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../components/branchInputField.dart';
import '../../../components/dateField.dart';
import '../../../components/dropDown.dart';
import '../../../utils/lists.dart';
import '../../login/screen/login.dart';
import '../screen/StudentForm.dart';

class InstallmentDetails extends StatefulWidget {
  InstallmentDetails({super.key,
    required this.formKey,
    required this.discountController,
    required this.installmentTypeController,
    required this.joiningDateController,
    required this.referenceByController,
    required this.partnerController,
    required this.isSubmitted
  });

  final TextEditingController discountController;
  final TextEditingController installmentTypeController;
  final TextEditingController joiningDateController;
  final TextEditingController referenceByController;
  final TextEditingController partnerController;
  final GlobalKey<FormState> formKey;
  final bool isSubmitted;

  @override
  State<InstallmentDetails> createState() => _InstallmentDetailsState();
}

class _InstallmentDetailsState extends State<InstallmentDetails> {

  @override
  void initState() {
    super.initState();

    widget.referenceByController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {}); // Triggers rebuild after the frame
        }
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,  // This ensures validation happens after interaction
      child: Column(
        children: [
          BranchInputTxt(
            label:  "Discount",
            textColor: black,
            type: "number",
            floatingLabelColor: preIconFillColor,
            controller: widget.discountController,
          ),
          DateField(
              firstDate: DateTime(1980, 1, 1),
              lastDate: DateTime.now(),
              label: "Joining Date",
              controller: widget.joiningDateController,
              validator: (value) {
                if (widget.isSubmitted && (value == null || value.isEmpty)) {
                  return "Please enter joining date";
                }
                return null;
              },
          ),

          SizedBox(height: 10,),
          DropDown(
            preSelectedValue: widget.referenceByController.text.isNotEmpty &&
                referenceBy.contains(widget.referenceByController.text)
                ? widget.referenceByController.text
                : (referenceBy.isNotEmpty ? referenceBy.first : ''),
            controller: widget.referenceByController,
            items: referenceBy,
            status: true,
            lbl: "Reference By",
          ),
          SizedBox(height: 10,),
            TextWidget(
              labelAlignment: Alignment.topLeft,
              label: "Select Partner",
              labelClr: black,
              labelFontWeight: FontWeight.normal,
              labelFontSize: px15,
            ),
            SizedBox(height: 3),
          if (widget.referenceByController.text.trim().toLowerCase() == "global it partner") ...[
            DropDown(
              preSelectedValue: widget.partnerController.text.isNotEmpty &&
                  partnerItems.contains(widget.partnerController.text)
                  ? widget.partnerController.text
                  : (partnerItems.isNotEmpty ? partnerItems.first : ''),
              controller: widget.partnerController,
              items: partnerItems,
              status: true,
              lbl: "Select Partner",
              onChanged: (selectedName) {
                setState(() {
                  widget.partnerController.text = selectedName;
                  partnerId = partnerMap[selectedName] ?? ''; // Get the corresponding ID
                });
              },
            ),
          ],
        ],
      ),
    );
  }
}