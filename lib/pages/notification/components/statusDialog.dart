import 'package:flutter/material.dart';
import '../../../common/color.dart';
import '../../../common/text.dart';
import '../../../main.dart';
import '../../../utils/common.dart';
import '../model/inquiryStatusListModel.dart';
import 'customDialogBox.dart';

class InquiryStatusDialog extends StatefulWidget {
  final bool? isInquiryReport;
  final InquiryStatusModel? inquiryList;
  final Function(String selectedId, String selectedStatusId,String selectedName) onPressed;
  final String? selectedStatus; //  to keep the previous selection

  const InquiryStatusDialog(
      {Key? key,
      this.isInquiryReport = false,
      required this.inquiryList,
      required this.onPressed,
      this.selectedStatus})
      : super(key: key);

  @override
  _InquiryStatusDialogState createState() => _InquiryStatusDialogState();
}

class _InquiryStatusDialogState extends State<InquiryStatusDialog> {
  String branchId = userBox.get(branchIdStr).toString();
  String createdBy = userBox.get(idStr).toString();
  String selectedId = '';
  String selectedName = '';
  String selectedStatusId = '';

  @override
  void initState() {
    super.initState();
    if (widget.selectedStatus != null) {
      selectedId = widget.selectedStatus!;
    } else {
      selectedId = '';
      selectedName = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return CustomDialog(
        title: "Status",
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.inquiryList!.inquiryStatusList!.length,
                  itemBuilder: (context, index) {
                    var status = widget.inquiryList!.inquiryStatusList![index];
                    bool isSelected = selectedId == status.id;

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedId = status.id!;
                            selectedName = status.name!;
                            selectedStatusId = status.status!;
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
                                status.name!,
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
                      callSnackBar("Please select a status", "danger");
                      return;
                    }
                    widget.onPressed(
                        selectedId, selectedStatusId, selectedName);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bv_primaryDarkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    widget.isInquiryReport! ? "FIND" : "UPDATE",
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
