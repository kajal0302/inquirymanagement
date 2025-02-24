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
    required this.isEdit,
  });

  final TextEditingController discountController;
  final TextEditingController installmentTypeController;
  final TextEditingController joiningDateController;
  final TextEditingController referenceByController;
  final TextEditingController partnerController;
  bool isEdit;
  final GlobalKey<FormState> formKey;

  @override
  State<InstallmentDetails> createState() => _InstallmentDetailsState();
}

class _InstallmentDetailsState extends State<InstallmentDetails> {
  String? _selectedOption = '';
  final bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          BranchInputTxt(
            label:  "Discount",
            textColor: black,
            floatingLabelColor: preIconFillColor,
            controller: widget.discountController,
            maxLength: 40,
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return "Please enter discount";
              }
              return null;
            },
          ),
          TextWidget(labelAlignment: Alignment.topLeft, label: "Installment Type", labelClr: black, labelFontWeight: FontWeight.bold, labelFontSize: px15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => _selectedOption = 'installment');
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'installment',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() => _selectedOption = value);
                      },
                    ),
                    const Text('Installment'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => _selectedOption = 'amount');
                },
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'amount',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() => _selectedOption = value);

                      },
                    ),
                    const Text('Amount'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
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
            onChanged: (str) {
              print(str);
            },
          ),
          SizedBox(height: 10,),
          // DropDown(
          //   preSelectedValue: widget.partnerController.text.isNotEmpty &&
          //       partnerItems.contains(widget.partnerController.text)
          //       ? widget.partnerController.text
          //       : (partnerItems.isNotEmpty ? partnerItems.first : ''),
          //   controller: widget.partnerController,
          //   items: partnerItems,
          //   status: true,
          //   lbl: "Select Partner",
          //   onChanged: (str) {
          //     print(str);
          //   },
          // ),


        ],
      ),
    );
  }
}