import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/components/InkWellInputField.dart';
import 'package:inquirymanagement/components/dateField.dart';
import 'package:inquirymanagement/components/dropDown.dart';
import 'package:inquirymanagement/pages/course/models/CourseModel.dart';
import 'package:inquirymanagement/pages/inquiry_report/model/inquiryModel.dart';
import 'package:inquirymanagement/pages/users/provider/BranchProvider.dart';

class StepTwo extends StatefulWidget {
  const StepTwo({
    super.key,
    required this.inquiry,
    required this.courses,
    required this.courseController,
    required this.selectBranch,
    required this.inquiryDate,
    required this.upcomingInquiryDate,
    required this.branchProvider,
    required this.isSubmitted,
    required this.onCourseSelectionChange,
  });

  final TextEditingController courseController,
      selectBranch,
      inquiryDate,
      upcomingInquiryDate;

  final bool isSubmitted;
  final Inquiries? inquiry;
  final CourseModel? courses;
  final BranchProvider branchProvider;
  final Function(CourseModel) onCourseSelectionChange;

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  List<String> courseName = [];
  List<String> courseIds = [];

  @override
  void initState() {
    super.initState();
    if (widget.inquiry != null) {
      widget.inquiry!.courses!.forEach((e) {
        courseName.add(e.name.toString());
        courseIds.add(e.id.toString());
      });
      widget.courseController.text = courseName.join(", ");
    }

    if (widget.courses != null &&
        widget.courses?.courses != null &&
        widget.courses!.courses!.isNotEmpty) {
      final selectedCourseIds =
          courseIds.map((e) => int.tryParse(e)).whereType<int>().toSet();

      widget.courses!.courses!.forEach((course) {
        course.isChecked =
            selectedCourseIds.contains(int.tryParse(course.id.toString()));
      });
    }
    setState(() {});
  }

  void _updateSelectedCourses(CourseModel updatedCourses) {
    widget.courseController.text = updatedCourses.courses!
        .where((c) => c.isChecked ?? false)
        .map((c) => c.name.toString())
        .join(", ");

    widget.onCourseSelectionChange(updatedCourses);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWellInputField(
          courses: widget.courses,
          context: context,
          label: "Select Course",
          readOnly: true,
          textColor: Colors.black,
          floatingLabelColor: preIconFillColor,
          controller: widget.courseController,
          validator: (value) {
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please Select Course'
                : null;
          },
          onOkPressed: _updateSelectedCourses,
        ),
        DropDown(
          preSelectedValue: widget.branchProvider.branch?.branches != null &&
                  widget.branchProvider.branch!.branches!
                      .any((b) => b.id.toString() == widget.selectBranch.text)
              ? widget.branchProvider.branch!.branches!
                  .firstWhere(
                      (b) => b.id.toString() == widget.selectBranch.text)
                  .id
                  .toString()
              : (widget.branchProvider.branch != null &&
                      widget.branchProvider.branch!.branches!.isNotEmpty
                  ? widget.branchProvider.branch!.branches!.first.id.toString()
                  : null),
          controller: widget.selectBranch,
          mapItems: widget.branchProvider.branch?.branches!
              .map((b) => {"id": b.id.toString(), "value": b.name.toString()})
              .toSet() // Ensure uniqueness
              .toList(),
          status: true,
          lbl: "Select Branch",
        ),
        DateField(
          firstDate: DateTime.now().subtract(Duration(days: 7 * 365)),
          lastDate: DateTime.now().add(Duration(days: 7 * 365)),
          label: "Inquiry Date",
          controller: widget.inquiryDate,
          validator: (value) {
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Inquiry Date'
                : null;
          },
        ),
        DateField(
          preDefine: DateTime.now().add(Duration(days: 1)),
          firstDate: DateTime.now().add(Duration(days: 1)),
          lastDate: DateTime.now().add(Duration(days: 7 * 365)),
          label: "Upcoming Inquiry Date",
          controller: widget.upcomingInquiryDate,
          validator: (value) {
            return widget.isSubmitted && (value == null || value.isEmpty)
                ? 'Please Enter Upcoming Inquiry Date'
                : null;
          },
        ),
      ],
    );
  }
}
