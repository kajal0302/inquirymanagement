import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/branchInputField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/pages/inquiry/models/PartnerModel.dart';
import 'package:inquirymanagement/utils/lists.dart';

class StepOne extends StatefulWidget {
  const StepOne({
    super.key,
    required this.fname,
    required this.lname,
    required this.mobileNo,
    required this.emailId,
    required this.reference,
    required this.feedback,
    required this.partnerModel,
    required this.partner,
    required this.isSubmitted,
  });

  final PartnerModel? partnerModel;

  final TextEditingController fname,
      lname,
      mobileNo,
      emailId,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.reference.text.isNotEmpty) {
        setState(() {
          selectedReference = widget.reference.text;
        });
      }
    });
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
          controller: widget.fname,
          maxLength: 50,
          validator: (value){
            return widget.isSubmitted && (value == null || value.isEmpty)
            ? 'Please enter First Name'
            : null;
          },
        ),
        BranchInputTxt(
          label: "Last Name",
          maxLength: 50,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.lname,
          validator: (value){
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
          validator: (value){
            if(widget.isSubmitted && (value == null || value.isEmpty)){
              return 'Please enter Mobile No.';
            }else if(value.toString().length < 10){
              return 'Minimum Length Should be 10';
            }else if(value.toString().length > 10){
              return 'Maximum Length Should be 10';
            }
            return null;
          },
        ),
        BranchInputTxt(
          label: "Email Id",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.emailId,
          type: "email",
          validator: (value){
            if(widget.isSubmitted && (value == null || value.isEmpty)){
              return 'Please enter Email Id';
            }else if(! EmailValidator(value ?? "")){
              return "Enter Valid EmailId";
            }else{
              return null;
            }
          },
        ),

        DropDown(
          preSelectedValue: selectedReference?.isNotEmpty == true
              ? selectedReference
              : (referenceBy.isNotEmpty ? referenceBy.first : ''),
          controller: widget.reference,
          items: referenceBy,
          status: true,
          lbl: "Select Reference",
          onChanged: (str) {
            setState(() {
              selectedReference = str;
              widget.reference.text = str;
            });
          },
        ),

        SizedBox(height: 8),
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
          label: "Feedback",
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.feedback,
          maxLines: 3,
          validator: (value){
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please enter Designation'
                : null;
          },
        ),

      ],
    );
  }
}