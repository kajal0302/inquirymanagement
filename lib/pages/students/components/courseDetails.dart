import 'package:flutter/material.dart';
import 'package:inquirymanagement/common/color.dart';
import 'package:inquirymanagement/pages/login/screen/login.dart';
import 'package:provider/provider.dart';
import '../../../common/size.dart';
import '../../../components/CustomCheckboxField.dart';
import '../../../components/DynamicStepper.dart';
import '../../../components/dropDown.dart';
import '../apicall/courseListApi.dart';
import '../models/courseListModel.dart';
import '../provider/categoryProvider.dart';
import '../screen/StudentForm.dart';

class CourseDetails extends StatefulWidget {
  CourseDetails({super.key,
    required this.formKey,
    required this.batchController,
    required this.categoryController,
    required this.courseController,
    required this.categoryProvider,
    required this.onCourseSelected,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController batchController;
  final TextEditingController categoryController;
  final TextEditingController courseController;
  final CategoryProvider categoryProvider;
  final Function(bool) onCourseSelected;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  List<Map<String, dynamic>> selectedCourses = []; // Stores selected courses with fees
  final bool isSubmitted = false;
  List<Map<String, dynamic>> courseItems = []; // Stores fetched course list


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      await categoryProvider.getCategory(context);

      if (categoryProvider.category != null &&
          categoryProvider.category!.categories != null &&
          categoryProvider.category!.categories!.isNotEmpty) {
        setState(() {
          categoryId = categoryProvider.category!.categories!.first.id.toString();
        });
      }
    });
    loadstudentCourseListData();
  }

  void _onCategoryChanged(String? selectedCategoryId) {
    if (selectedCategoryId != null && selectedCategoryId != categoryId) {
      categoryId = selectedCategoryId;

      if (mounted) {
        setState(() {
          widget.categoryController.text = selectedCategoryId;
        });
      }


      // Load student course list
      loadstudentCourseListData();

    }
  }


  // Load Course List Data
  Future<void> loadstudentCourseListData() async {
    StudentCourseListModel? fetchedCourseListData =
    await fetchStudentCourseListData(context,categoryId.toString());
    setState(() {
      if (fetchedCourseListData != null &&
          fetchedCourseListData.courses != null &&
          fetchedCourseListData.courses!.isNotEmpty) {
        courseItems = fetchedCourseListData.courses!.map((item) => {
          "id": item.id.toString(),
          "value": item.name ?? '',
          "total_fee": int.tryParse(item.fees ?? '0') ?? 0,
        }).toList();
      } else {
        courseItems = [];
      }
    });
  }

  // Calculate total fee of selected courses
  double getTotalFee() {
    return selectedCourses.fold(0, (sum, course) {
      double fee = double.tryParse(course["total_fee"].toString()) ?? 0.0;
      return sum + fee;
    });
  }



  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomCheckBoxTextField(
              title: "Select Batch",
              controller: widget.batchController,
              items: batchItems,
              titleText: "-- Select Batch --",
              status: true,
              includeAllCheckbox: false,
              selectedItems: selectedBatchItems,
              validator: (value) {
                if (isSubmitted &&
                    (value == null || value.isEmpty)) {
                  return 'Please select a Batch';
                }
                return null;
              }),
          SizedBox(height: 10,),
          TextWidget(labelAlignment: Alignment.topLeft, label: "Select Standard", labelClr: black, labelFontWeight: FontWeight.normal, labelFontSize: px15),
          DropDown(
            preSelectedValue: (categoryProvider.category != null &&
                categoryProvider.category!.categories != null &&
                categoryProvider.category!.categories!
                    .any((b) => b.id.toString() == widget.categoryController.text))
                ? widget.categoryController.text
                : (categoryProvider.category != null &&
                categoryProvider.category!.categories != null &&
                categoryProvider.category!.categories!.isNotEmpty
                ? categoryProvider.category!.categories!.first.id.toString()
                : ""),
            controller: widget.categoryController,
            mapItems: (categoryProvider.category != null &&
                categoryProvider.category!.categories != null)
                ? categoryProvider.category!.categories!
                .map((b) => {"id": b.id.toString(), "value": b.name.toString()})
                .toSet()
                .toList()
                : [],
            status: true,
            lbl: "Select Category",
            onChanged: _onCategoryChanged,
          ),
          CustomCheckBoxTextField(
            title: "Select Course",
            controller: widget.courseController,
            items: courseItems.map((e) => e["value"]).toList(),
            titleText: "-- Select Course --",
            status: true,
            includeAllCheckbox: true,
            selectedItems: selectedCourses.map((e) => e["value"].toString()).toList(),
            onChanged: (newSelectedItems) {
              setState(() {
                selectedCourses = courseItems
                    .where((course) => newSelectedItems.contains(course["value"]))
                    .toList();

                // Update the controller with the selected items
                widget.courseController.text = selectedCourses.map((e) => e["value"]).join(", ");

                // Update the course selection status
                isCourseSelected = selectedCourses.isNotEmpty;
              });
            },
            validator: (value) {
              if (isSubmitted && (value == null || value.isEmpty)) {
                return 'Please select a Course';
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          // Display Selected Courses & Total Fee

        if (selectedCourses.isNotEmpty)
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Course List",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Price",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1),

          // Course List
          Column(
            children: selectedCourses.map((course) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        course["value"],
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "₹${course["total_fee"] ?? 0}",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Divider(thickness: 1),

          // Total Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    "₹${getTotalFee()}",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )

    ],
      ),
    );
  }

}

