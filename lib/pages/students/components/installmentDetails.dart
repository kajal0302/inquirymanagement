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
  });

  final TextEditingController discountController;
  final TextEditingController installmentTypeController;
  final TextEditingController joiningDateController;
  final TextEditingController referenceByController;
  final TextEditingController partnerController;
  final GlobalKey<FormState> formKey;

  @override
  State<InstallmentDetails> createState() => _InstallmentDetailsState();
}

class _InstallmentDetailsState extends State<InstallmentDetails> {
  final bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BranchInputTxt(
            label:  "Discount",
            textColor: black,
            type: "number",
            floatingLabelColor: preIconFillColor,
            controller: widget.discountController,
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return "Please enter discount";
              }
              return null;
            },
          ),
          DateField(
              firstDate: DateTime(1980, 1, 1),
              lastDate: DateTime.now(),
              label: "Joining Date",
              controller: widget.joiningDateController),

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
          if (widget.referenceByController.text.isNotEmpty) ...[
            TextWidget(
              labelAlignment: Alignment.topLeft,
              label: "Select Partner",
              labelClr: black,
              labelFontWeight: FontWeight.normal,
              labelFontSize: px15,
            ),
            SizedBox(height: 3),
            DropDown(
              preSelectedValue: widget.partnerController.text.isNotEmpty &&
                  partnerItems.contains(widget.partnerController.text)
                  ? widget.partnerController.text
                  : (partnerItems.isNotEmpty ? partnerItems.first : ''),
              controller: widget.partnerController,
              items: partnerItems,
              status: true,
              lbl: "Select Partner",
              onChanged: (str) {
                setState(() {
                  widget.partnerController.text = str;
                  print("Selected Partner: ${widget.partnerController.text}");
                });
              },

            ),
          ],
        ],
      ),
    );
  }
}