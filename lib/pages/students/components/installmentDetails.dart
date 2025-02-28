import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/size.dart';
import '../../../components/branchInputField.dart';
import '../../../components/dateField.dart';
import '../../../components/dropDown.dart';
import '../../../utils/lists.dart';
import '../../inquiry/models/PartnerModel.dart';
import '../../login/screen/login.dart';
import '../screen/StudentForm.dart';

class InstallmentDetails extends StatefulWidget {
  InstallmentDetails({super.key,
    required this.formKey,
    required this.discountController,
    required this.installmentTypeController,
    required this.joiningDateController,
    required this.referenceByController,
    required this.partnerModel,
    required this.partnerController,
    required this.isSubmitted
  });

  final PartnerModel? partnerModel;
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
  String? selectedReference;

  @override
  void initState() {
    super.initState();
    selectedReference = widget.referenceByController.text;
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
            key: Key('dropDown1'),
            preSelectedValue: selectedReference?.isNotEmpty == true
                ? selectedReference
                : (referenceBy.isNotEmpty ? referenceBy.first : ''),
            controller: widget.referenceByController,
            items: referenceBy,
            status: true,
            lbl: "Select Reference",
            onChanged: (value) {
              setState(() {
                selectedReference = value;
                widget.referenceByController.text = value;
              });
            },
          ),
          SizedBox(height: 10,),
          if (selectedReference!.trim().toLowerCase() == "global it partner") ...[
            TextWidget(
              labelAlignment: Alignment.topLeft,
              label: "Select Partner",
              labelClr: black,
              labelFontWeight: FontWeight.normal,
              labelFontSize: px15,
            ),
            SizedBox(height: 3),
            DropDown(
              preSelectedValue: widget.partnerModel?.partners != null &&
                  widget.partnerModel!.partners!
                      .any((b) => b.id.toString() == widget.partnerController.text)
                  ? widget.partnerController.text
                  : (widget.partnerModel?.partners != null &&
                  widget.partnerModel!.partners!.isNotEmpty
                  ? widget.partnerModel?.partners!.first.id.toString()
                  : null),
              controller: widget.partnerController,
              mapItems: widget.partnerModel?.partners!
                  .map((b) =>
              {"id": b.id.toString(), "value": b.partnerName.toString()})
                  .toSet()
                  .toList(),
              status: true,
              lbl: "Select Partner",
            ),
          ],
        ],
      ),
    );
  }
}