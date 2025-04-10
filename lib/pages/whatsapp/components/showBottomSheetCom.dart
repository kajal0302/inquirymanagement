import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/common/size.dart';
import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/text.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/pages/whatsapp/components/StudentCheckedCard.dart';

void showBottomSheetCom(
    BuildContext context, List<Inquiries>? inquiryListFilter) {
  bool _isAllSelected = false;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5, // Starts at 50% of screen height
        minChildSize: 0.3, // Can be dragged to 30% of screen height
        maxChildSize: 0.8, // Can be expanded to 80% of screen height
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 10.0),
                    color: Colors.grey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Student List",
                          style: TextStyle(
                            color: colorBlackAlpha,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          activeColor: primaryColor,
                          value: _isAllSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              _isAllSelected =
                                  value ?? false; // Set to the current value

                              // Update all students' checkboxes based on _isAllSelected
                              if (inquiryListFilter != null) {
                                for (var student in inquiryListFilter) {
                                  student.isChecked = _isAllSelected;
                                }
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: white,
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        controller: scrollController,
                        shrinkWrap: true,
                        itemCount: inquiryListFilter!.length,
                        itemBuilder: (context, index) {
                          final student = inquiryListFilter[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: px8),
                            child: GestureDetector(
                              child: StudentCheckedCard(
                                title: "${student.fname} ${student.lname}",
                                subTitle: "${student.contact}",
                                img: userImageUri,
                                id: '${student.id}',
                                isChecked: student.isChecked ?? false,
                                onChange: (isChecked) {
                                  setState(() {
                                    student.isChecked = isChecked;
                                    _isAllSelected = inquiryListFilter.every(
                                        (student) => student.isChecked == true);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
