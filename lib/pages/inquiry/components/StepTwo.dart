import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/InkWellInputField.dart';
import 'package:inquirymanagement/components/dateField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';

class StepTwo extends StatelessWidget {
  const StepTwo(
      {super.key,
      required this.course,
      required this.coursesId,
      required this.branch,
      required this.inquiryDate,
      required this.selectBranch,
      required this.upcomingDate,
      required this.smsType,
      required this.branchProvider,
      required this.courses,
      required this.isSubmitted});

  final TextEditingController course,
      coursesId,
      branch,
      inquiryDate,
      selectBranch,
      upcomingDate,
      smsType;

  final bool isSubmitted;
  final CourseModel? courses;
  final BranchProvider branchProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWellInputField(
          courses: courses,
          context: context,
          label: "Select Course",
          readOnly: true,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: course,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Select Course'
                : null;
          },
          onOkPressed: (CourseModel updatedCourses) {
            List<String?> selectedCourses = updatedCourses.courses!
                .where((course) => course.isChecked == true)
                .map((course) => course.name)
                .toList();

            List<String?> selectedCoursesId = updatedCourses.courses!
                .where((course) => course.isChecked == true)
                .map((course) => course.id.toString())
                .toList();

            course.text = selectedCourses.join(", ");
            coursesId.text = selectedCoursesId.join(",");
          },
        ),

        DropDown(
          preSelectedValue: branchProvider.branch?.branches != null &&
              branchProvider.branch!.branches!
                  .any((b) => b.id.toString() == selectBranch.text)
              ? selectBranch.text
              : (branchProvider.branch != null &&
              branchProvider.branch!.branches!.isNotEmpty
              ? branchProvider.branch!.branches!.first.id.toString()
              : null),
          controller: selectBranch,
          mapItems: branchProvider.branch?.branches!
              .map((b) => {"id": b.id.toString(), "value": b.name.toString()})
              .toSet() // Ensure uniqueness
              .toList(),
          status: true,
          lbl: "Select Branch",
        ),
        DateField(
          firstDate: DateTime(1980, 1, 1),
          lastDate: DateTime.now(),
          label: "Inquiry Date",
          controller: inquiryDate,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Inquiry Date'
                : null;
          },
        ),

        DateField(
          firstDate: DateTime.now().subtract(Duration(days: 5 * 365)), /// included 5 years before date from today
          lastDate: DateTime.now().add(Duration(days: 5 * 365)), /// included 5 years in future date from today
          label: "Upcoming Inquiry Date",
          controller: upcomingDate,
          validator: (value) {
            return isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Upcoming Inquiry Date'
                : null;
          },
        ),
      ],
    );
  }


}
