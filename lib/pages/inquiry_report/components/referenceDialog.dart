import 'package:flutter/material.dart';
import 'package:inquirymanagement/utils/lists.dart';
import '../../../common/color.dart';
import '../../../common/text.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../../notification/components/customDialogBox.dart';

class InquiryReferenceDialog extends StatefulWidget {
  final Function(String) onPressed;

  const InquiryReferenceDialog({Key? key, required this.onPressed})
      : super(key: key);

  @override
  _InquiryReferenceDialogState createState() => _InquiryReferenceDialogState();
}

class _InquiryReferenceDialogState extends State<InquiryReferenceDialog> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  String selectedId = '';
  String selectedName = '';

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return CustomDialog(
        title: "Reference",
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: referenceBy.length-1,
                  itemBuilder: (context, index) {
                    var reference = referenceBy[index+1];
                    bool isSelected = selectedId == reference;

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedId = reference;
                            selectedName = reference;
                          });
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 15),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected ? preIconFillColor : grey_500,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                reference,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? preIconFillColor : black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedId.isEmpty) {
                      callSnackBar("Please select a reference", "danger");
                      return;
                    }
                    widget.onPressed(selectedName);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bv_primaryDarkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "FIND",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

