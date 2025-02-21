import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/branchInputField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/pages/inquiry/models/PartnerModel.dart';
import 'package:inquirymanagement/utils/lists.dart';

class StepOne extends StatefulWidget {
  const StepOne({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.feedback,
    required this.reference,
    required this.partnerModel,
    required this.partner,
    required this.isSubmitted,
  });

  final PartnerModel? partnerModel;

  final TextEditingController firstName,
      lastName,
      mobileNo,
      feedback,
      partner,
      reference;

  final bool isSubmitted;

  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  String? selectedReference;

  @override
  void initState() {
    super.initState();
    selectedReference = widget.reference.text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        BranchInputTxt(
          label: "First Name",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.firstName,
          maxLength: 50,
          validator: (value) {
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter First Name'
                : null;
          },
        ),

        BranchInputTxt(
          label: "Last Name",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.lastName,
          maxLength: 50,
          validator: (value) {
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Last Name'
                : null;
          },
        ),

        BranchInputTxt(
          label: "Mobile No.",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.mobileNo,
          type: "number",
          maxLength: 10,
          validator: (value) {
            if (widget.isSubmitted && (value == null || value.isEmpty)) {
              return 'Please enter Mobile No.';
            } else if (value.toString().length < 10) {
              return 'Minimum Length Should be 10';
            } else if (value.toString().length > 10) {
              return 'Maximum Length Should be 10';
            }
            return null;
          },
        ),

        DropDown(
          key: Key('dropDown1'),
          preSelectedValue: selectedReference?.isNotEmpty == true
              ? selectedReference
              : (referenceBy.isNotEmpty ? referenceBy.first : ''),
          controller: widget.reference,
          items: referenceBy,
          status: true,
          lbl: "Select Reference",
          onChanged: (str) {
            print(str);
            setState(() {
              selectedReference = str;
              widget.reference.text = str; // Ensure controller updates
            });
          },
        ),
        SizedBox(height: 8,),
        if (selectedReference == "Global IT Partner")
          DropDown(
            preSelectedValue: widget.partnerModel?.partners != null &&
                widget.partnerModel!.partners!
                    .any((b) => b.id.toString() == widget.partner.text)
                ? widget.partner.text
                : (widget.partnerModel?.partners != null &&
                widget.partnerModel!.partners!.isNotEmpty
                ? widget.partnerModel?.partners!.first.id.toString()
                : null),
            controller: widget.partner,
            mapItems: widget.partnerModel?.partners!
                .map((b) =>
            {"id": b.id.toString(), "value": b.partnerName.toString()})
                .toSet()
                .toList(),
            status: true,
            lbl: "Select Partner",
          ),

        BranchInputTxt(
          label: "Feedback History",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.feedback,
          maxLength: 50,
          validator: (value) {
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Feedback History'
                : null;
          },
        ),

      ],
    );
  }
}
